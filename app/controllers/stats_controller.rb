class StatsController < ApplicationController
  def nw_s
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.order(nw_s_rate: :desc, nw_s_win: :desc).page(params[:page])
    @info = UserInfo.joins(:users).where(users: {season: @season})
  end

  def nw_d
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.order(nw_d_rate: :desc, nw_d_win: :desc).page(params[:page])
    @info = UserInfo.joins(:users).where(users: {season: @season})
  end

  def ow_s
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.order(ow_s_rate: :desc, ow_s_win: :desc).page(params[:page])
    @info = UserInfo.joins(:users).where(users: {season: @season})
  end

  def ow_d
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.order(ow_d_rate: :desc, ow_d_win: :desc).page(params[:page])
    @info = UserInfo.joins(:users).where(users: {season: @season})
  end
  def logs
    @season = params[:q].blank? || params[:q][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:q][:season])
    @q = @season.matches.ransack(params[:q])
    @logs = @q.result.order(created_at: :desc).page(params[:page])
  end
end
