class UsersController < ApplicationController
  def index
    @season = params[:q].blank? || params[:q][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:q][:season])
    @q = @season.users.ransack(params[:q])
    @user = @q.result.order(created_at: :desc).page(params[:page])
  end

  def show
    @season = params[:season].blank? || params[:season][:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season][:season])
    user = User.find_by(id: params[:id])
    @info = UserInfo.includes(:name_histories).find_by(id: user.user_info_id)
    names = @info.name_histories.pluck(:name)
    @state = !@season.users.find_by(id: params[:id]).nil?
    if @state
      @user = @season.users.find_by(id: params[:id])
      @q = @season.matches.ransack(params[:q])
      @logs = @q.result.where(redname1: names).or(@q.result.where(redname2: names)).or(@q.result.where(bluename1: names)).or(@q.result.where(bluename2: names)).order(created_at: :desc).page(params[:page])
    end
  end

  def rename
    if !logged_in? || params[:rename][:name].blank?
      return
    end
    User.transaction do
      user = User.where(season: params[:rename][:season]).find_by(id: params[:user_id])
      user.name = params[:rename][:name]
      user.save!
      info = UserInfo.find_by(id: params[:info])
      info.name = params[:rename][:name]
      info.save!
      NameHistory.create!(name: params[:rename][:name], user_info: info)
      flash[:success] = "名前を変更しました"
    end
    redirect_to user_show_path(user_id: params[:user_id], info: params[:info])
  end

  def delete
    if logged_in?
      if params[:season].blank?
        if UserInfo.find_by(id: params[:id]).destroy
          flash[:success] = "全データを削除しました"
          redirect_to users_path
        else
          flash[:warning] = "削除に失敗しました"
          redirect_to request.referer
        end
      else
        season = Season.find_by(id: params[:season])
        if season.users.find_by(id: params[:id]).delete
          flash[:success] = season.name + "のデータを削除しました"
          redirect_to users_path
        else
          flash[:warning] = "削除に失敗しました"
          redirect_to request.referer
        end
      end
    end
  end
end
