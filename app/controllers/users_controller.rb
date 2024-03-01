class UsersController < ApplicationController
  def index
    @user = User.all.order(name: :desc).page(params[:page])
  end

  def show
    @user = User.where(id: params[:id])
  end
end
