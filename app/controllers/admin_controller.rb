class AdminController < ApplicationController
  def season
    @seasons = Season.all.order(created_at: :desc)
  end

  def new_season
    Season.new.new_season(params[:season][:name])
    redirect_to season_admin_index_path
  end

  def delete_season
    season = Season.find_by(id: params[:id])
    if (season.finished_at)
      if (season.destroy)
        flash[:success] = "削除しました"
      else
        flash[:warning] = "削除に失敗しました"
      end
    else
      flash[:warning] = "選択したシーズンは進行中です。"
    end
    redirect_to season_admin_index_path
  end
end
