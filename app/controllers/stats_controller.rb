class StatsController < ApplicationController
  def nw_s
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.where.not(nw_s_win: 0, nw_s_lose: 0).order(nw_s_rate: :desc, nw_s_win: :desc, updated_at: :asc).page(params[:page])
  end

  def nw_d
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.where.not(nw_d_win: 0, nw_d_lose: 0).order(nw_d_rate: :desc, nw_d_win: :desc, updated_at: :asc).page(params[:page])
  end

  def ow_s
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.where.not(ow_s_win: 0, ow_s_lose: 0).order(ow_s_rate: :desc, ow_s_win: :desc, updated_at: :asc).page(params[:page])
  end

  def ow_d
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.where.not(ow_d_win: 0, ow_d_lose: 0).order(ow_d_rate: :desc, ow_d_win: :desc, updated_at: :asc).page(params[:page])
  end

  def dma
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    @stats = @season.users.where.not(dma_win: 0, dma_lose: 0).order(dma_rate: :desc, dma_win: :desc, updated_at: :asc).page(params[:page])
  end
  
  def logs
    @season = params[:q].blank? || params[:q][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:q][:season])
    @q = @season.matches.ransack(params[:q])
    @logs = @q.result.order(created_at: :desc).page(params[:page])
  end
end
