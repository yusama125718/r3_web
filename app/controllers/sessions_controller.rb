class SessionsController < ApplicationController
  def new
  end

  def create
    user = Account.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = (t "flash.login")
      redirect_to root_path
    else
      flash[:warning] = (t "flash.login_fail")
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = (t "flash.logout")
    redirect_to root_path
  end
end
