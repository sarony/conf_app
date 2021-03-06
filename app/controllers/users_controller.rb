class UsersController < ApplicationController
  before_filter :signed_in_user,          only: [:edit, :update]
  before_filter :correct_user,            only: [:edit, :update]
  before_filter :admin_user,              only: :destroy
  before_filter :skip_password_attribute, only: :update
  
  def index
    @users = User.page(params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to Woodrow Wilson Events!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  
  private

    # Requires that :user be a key in the params Hash and
 		# only accept :name, :email, :password, and :password_confirmation attr
  	def user_params
  		params.require(:user).permit(:first_name, :last_name, :email, :job_title,
                                   :employer, :bio, :current_project, :privacy,
  																 :password, :password_confirmation)
  	end

    # Before actions

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def skip_password_attribute
      if params[:password].blank? && params[:password_confirmation].blank?
        params.except!(:password, :password_confirmation)
      end
    end
end