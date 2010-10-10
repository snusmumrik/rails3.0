class UsersController < ApplicationController
  # # render new.rhtml
  # def new
  #   @user = User.new
  # end
  #
  # def create
  #   logout_keeping_session!
  #   @user = User.new(params[:user])
  #   success = @user && @user.save
  #   if success && @user.errors.empty?
  #     redirect_back_or_default('/', :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
  #   else
  #     flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
  #     render :action => 'new'
  #   end
  # end
  #
  # def activate
  #   logout_keeping_session!
  #   user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
  #   case
  #   when (!params[:activation_code].blank?) && user && !user.active?
  #     user.activate!
  #     redirect_to '/login', :notice => "Signup complete! Please sign in to continue."
  #   when params[:activation_code].blank?
  #     redirect_back_or_default('/', :flash => { :error => "The activation code was missing.  Please follow the URL from your email." })
  #   else
  #     redirect_back_or_default('/', :flash => { :error  => "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in." })
  #   end
  # end

  layout 'application'
  before_filter :not_logged_in_required, :only => [:new, :create]
  before_filter :login_required, :only => [:show, :edit, :update]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]

  def index
      @users = User.find(:all)
  end

  #This show action only allows users to view their own profile
  def show
      @user = current_user
  end

  # render new.rhtml
  def new
    @user = User.new
  end
  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.save!
    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
    redirect_to login_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account."
    render :action => 'new'
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'show', :id => current_user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
      redirect_to :action => 'index'
  end
end
