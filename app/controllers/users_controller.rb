class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    #@users = User.all
    @users = User.paginate(page:params[:page])
  end
  
  def show 
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save # => Validation
      #Success
      flash[:success] = "Welcome to the Sample App!"
      log_in @user
      redirect_to @user
      # => "/users/#{@user.id}"
    else
      #Failure
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    # app/views/edit.html.erb
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #Success
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      #Failure
      # @user.errors.full_message()
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(
        :name,:email,:password,
        :password_confirmation)
    end
  
    #beforeアクション
    
    #ログイン済ユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end