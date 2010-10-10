require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :permissions
  has_many :roles, :through => :permissions

  set_table_name 'users'

  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 3..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation


  # # Activates the user in the database.
  # def activate!
  #   @activated = true
  #   self.activated_at = Time.now.utc
  #   self.activation_code = nil
  #   save(:validate => false)
  # end
  # 
  # # Returns true if the user has just been activated.
  # def recently_activated?
  #   @activated
  # end
  # 
  # def active?
  #   # the existence of an activation code means they have not activated yet
  #   activation_code.nil?
  # end
  # 
  # # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  # #
  # # uff.  this is really an authorization, not authentication routine.  
  # # We really need a Dispatch Chain here or something.
  # # This will also let us return a human error message.
  # #
  # def self.authenticate(login, password)
  #   return nil if login.blank? || password.blank?
  #   u = where(['login = ? and activated_at IS NOT NULL', login]).first # need to get the salt
  #   u && u.authenticated?(password) ? u : nil
  # end
  # 
  # def login=(value)
  #   write_attribute :login, (value ? value.downcase : nil)
  # end
  # 
  # def email=(value)
  #   write_attribute :email, (value ? value.downcase : nil)
  # end
  # 
  # protected
  #   
  # def make_activation_code
  #     self.activation_code = self.class.make_token
  # end

  class ActivationCodeNotFound < StandardError; end
  class AlreadyActivated < StandardError
    attr_reader :user, :message;
    def initialize(user, message=nil)
      @message, @user = message, user
    end
  end

  # Finds the user with the corresponding activation code, activates their account and returns the user.
  # 
  # Raises:
  #  +User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
  #  +User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
  def self.find_and_activate!(activation_code)
    raise ArgumentError if activation_code.nil?
    user = find_by_activation_code(activation_code)
    raise ActivationCodeNotFound if !user
    raise AlreadyActivated.new(user) if user.active?
    user.send(:activate!)
    user
  end
  def active?
    # the presence of an activation date means they have activated 
    !activated_at.nil?
  end
  # Returns true if the user has just been activated.
  def pending?
    @activated
  end
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  # Updated 2/20/08
  def self.authenticate(login, password)    
    u = find :first, :conditions => ['login = ?', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil  
  end
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end
  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end
  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end  
  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  def recently_reset_password?
    @reset_password
  end

  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
  end

  def has_role?(rolename)
    self.roles.find_by_rolename(rolename) ? true : false
  end

  protected

  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  private

  def activate!
    @activated = true
    self.update_attribute(:activated_at, Time.now.utc)
  end
end
