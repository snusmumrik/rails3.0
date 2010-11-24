class UsersController < ApplicationController
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
    @image = Image::UserImage.new(params[:image])
    @user.images << @image if @image.image_file_size

    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    redirect_to signin_path, :notice => "Thanks for signing up! Please check your email to activate your account before logging in."
  rescue ActiveRecord::RecordInvalid
    render :action => 'new', :error => "There was a problem creating your account."
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      # save attached images
      @image = Image::UserImage.new(params[:image])
      @user.images << @image if @image.image_file_size

      # delete checked images
      params[:delete_images].each do |id|
        @delete_image = Image::UserImage.find(id)
        @delete_image.deleted_at = Time.now
        @delete_image.save!
      end

      redirect_to @user, :notice => "User updated"
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
