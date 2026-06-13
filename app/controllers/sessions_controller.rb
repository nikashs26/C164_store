class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      user.create_cart! unless user.cart
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

  private

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
