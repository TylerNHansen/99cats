class SessionsController < ApplicationController
  before_action :require_logged_out
  skip_before_action :require_logged_out, only: [:destroy]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user])
    if @user
      login!(@user)
      redirect_to root_url
    else
      flash.now[:errors] = ["Invalid username and/or password"]
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end

  private

  def require_logged_out
    if logged_in?
      flash[:errors] = ['You are already logged in!']
      redirect_to root_url
    end
  end
end
