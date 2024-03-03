class UsersController < ApplicationController
  def index
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @user = @season.users.page(params[:page])
    @info = UserInfo.joins(:users).where(users: {season: @season})
  end

  def show
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @info = UserInfo.find_by(id: params[:info])
    @state = !@season.users.find_by(id: params[:user_id]).nil?
    if @state
      @user = @season.users.find_by(id: params[:user_id])
      @q = @season.matches.ransack(params[:q])
      @logs = @q.result.where(redname1: @info.name).or(@q.result.where(redname2: @info.name)).or(@q.result.where(bluename1: @info.name)).or(@q.result.where(bluename2: @info.name)).order(created_at: :desc).page(params[:page])
    end
  end
end
