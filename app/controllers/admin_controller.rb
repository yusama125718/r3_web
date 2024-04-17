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
    redirect_to action: :season
  end

  def edit_season
    render "edit"
  end

  def update_season
    season = Season.find_by(id: params[:id])
    if season.nil?
      flash.now[:warning] = "シーズンが存在しません"
    else
      season.message = params[:message]
      if season.save
        flash[:success] = "メッセージを更新しました"
      else
        flash.now[:warning] = "シーズンが存在しません"
      end
    end
    redirect_to action: :season
  end
end
