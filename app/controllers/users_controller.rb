class UsersController < ApplicationController
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
  
  def user_params
    params.require(:user).permit(
      :name,:email,:password,
      :password_confirmation)
  end
end