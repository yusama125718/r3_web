class SessionsController < ApplicationController
  def new
  end

  def create
    user = Account.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "ログインしました"
      redirect_to root_path
    else
      flash[:warning] = "ログインに失敗しました"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました"
    redirect_to root_path
  end
end
