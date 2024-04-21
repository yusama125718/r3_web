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
        flash[:success] = (t "flash.delete_complete")
      else
        flash[:warning] = (t "flash.delete_fail")
      end
    else
      flash[:warning] = (t "flash.season_during")
    end
    redirect_to action: :season
  end

  def edit_season
    render "edit"
  end

  def update_season
    season = Season.find_by(id: params[:id])
    if season.nil?
      flash.now[:warning] = (t "flash.season_notthing")
    else
      season.message = params[:message]
      if season.save
        flash[:success] = (t "flash.message_update")
      else
        flash.now[:warning] = (t "flash.message_fail")
      end
    end
    redirect_to action: :season
  end
end
