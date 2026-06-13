class UsersController < ApplicationController
  before_action :require_login, only: [ :show ]
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      @user.create_cart!
      flash[:notice] = "Welcome, #{@user.name}!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
