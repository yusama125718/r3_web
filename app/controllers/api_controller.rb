class ApiController < ApplicationController
  skip_forgery_protection

  # リザルト受け取り処理
  def create
    if Settings.api_key != params[:api_key] 
      return
    end
    # NPCがいる場合弾く
    # if params[:name_a1].start_with?("NPC ") || params[:name_a2].start_with?("NPC ") || params[:name_b1].start_with?("NPC ") || params[:name_b2].start_with?("NPC ")
    #   return
    # end
    # if params[:name_a1].start_with?("AI ") || params[:name_a2].start_with?("AI ") || params[:name_b1].start_with?("AI ") || params[:name_b2].start_with?("AI ")
    #   return
    # end
    season = Season.find_by(finished_at: nil)
    # シングルスかダブルスか判定
    is_single = (params[:name_a1] == "" || params[:name_a2] == "") && (params[:name_b1] == "" || params[:name_b2] == "") && (params[:name_a1] != "" || params[:name_a2] != "") && (params[:name_b1] != "" || params[:name_b2] != "")
    # シングルスだった場合[0]がblankにならないように代入
    if is_single
      red = params[:name_a2] == "" ? [params[:name_a1], ""] : [params[:name_a2], ""]
      blue = params[:name_b2] == "" ? [params[:name_b1], ""] : [params[:name_b2], ""]
    else
      return
    # 今のとこシングルスのみ想定なのでコメントアウト
    # else
    #   red = [params[:name_a1], params[:name_a2]]
    #   blue = [params[:name_b1], params[:name_b2]]
    end
    # ユーザーデータがなかったら作成
    if red[0] != ""
      red_info = [UserInfo.find_by(name: red[0]), nil]
      if red_info[0].nil?
        red_info[0] = UserInfo.create!(name: red[0])
        NameHistory.create!(name: red[0], user_info: red_info[0])
      end 
      reduser = [season.users.find_by(user_info: red_info[0]), nil]
      if reduser[0].nil?
        reduser[0] = User.create!(name: red[0], user_info: red_info[0], season_id: season.id)
      end
    end 
    # 今のとこシングルスのみ想定なのでコメントアウト
    # if red[1] != ""
    #   red_info[1] = UserInfo.find_by(name: red[1])
    #   if red_info[1].nil?
    #     red_info[1] = UserInfo.create!(name: red[1])
    #     NameHistory.create!(name: red[1], user_info: red_info[1])
    #   end 
    #   reduser[1] = season.users.find_by(user_info: red_info[1])
    #   if reduser[1].nil?
    #     reduser[1] = User.create!(name: red[1], user_info: red_info[1], season_id: season.id)
    #   end
    # end 
    if blue[0] != ""
      blue_info = [UserInfo.find_by(name: blue[0]), nil]
      if blue_info[0].nil?
        blue_info[0] = UserInfo.create!(name: blue[0])
        NameHistory.create!(name: blue[0], user_info: blue_info[0])
      end 
      blueuser = [season.users.find_by(user_info: blue_info[0]), nil]
      if blueuser[0].nil?
        blueuser[0] = User.create!(name: blue[0], user_info: blue_info[0], season_id: season.id)
      end
    end 
    # 今のとこシングルスのみ想定なのでコメントアウト
    # if blue[1] != ""
    #   blue_info[1] = UserInfo.find_by(name: blue[1])
    #   if info.nil?
    #     blue_info[1] = UserInfo.create!(name: blue[1])
    #     NameHistory.create!(name: blue[1], user_info: blue_info[1])
    #   end 
    #   blueuser[1] = season.users.find_by(user_info: blue_info[1])
    #   if blueuser[1].nil?
    #     blueuser[1] = User.create!(name: blue[1], user_info: blue_info[1], season_id: season.id)
    #   end
    # end 
    score_red = params[:score_a]
    score_blue = params[:score_b]
    guid = params[:guid]
    hopping_allowed = params[:hopping_allowed] == "on"
    game_double = params[:game_double] == "on"
    game_ex_speed = params[:game_ex_speed]
    game_boundaries = params[:game_boundaries] == "on"
    score_max = params[:score_max]
    # シングルス専用レート計算処理
    if score_red > score_blue
      winner = "red"
      if game_boundaries && game_double
        rate = GetRate(red_info[0].ow_d_rate, score_red, blue_info[0].ow_d_rate, score_blue, score_max)
      elsif game_boundaries && !game_double
        rate = GetRate(red_info[0].ow_s_rate, score_red, blue_info[0].ow_s_rate, score_blue, score_max)
      elsif !game_boundaries && game_double
        rate = GetRate(red_info[0].nw_d_rate, score_red, blue_info[0].nw_d_rate, score_blue, score_max)
      elsif !game_boundaries && !game_double
        rate = GetRate(red_info[0].nw_s_rate, score_red, blue_info[0].nw_s_rate, score_blue, score_max)
      end
    else
      winner = "blue"
      if game_boundaries && game_double
        rate = GetRate(blue_info[0].ow_d_rate, score_blue, red_info[0].ow_d_rate, score_red, score_max)
      elsif game_boundaries && !game_double
        rate = GetRate(blue_info[0].ow_s_rate, score_blue, red_info[0].ow_s_rate, score_red, score_max)
      elsif !game_boundaries && game_double
        rate = GetRate(blue_info[0].nw_d_rate, score_blue, red_info[0].nw_d_rate, score_red, score_max)
      elsif !game_boundaries && !game_double
        rate = GetRate(blue_info[0].nw_s_rate, score_blue, red_info[0].nw_s_rate, score_red, score_max)
      end
    end
    # guidのかぶりがなかったら試合結果を追加
    if !season.matches.exists?(guid: guid)
      if winner == "red"
        winner_name = red
        winner_info = red_info
        loser_name = blue
        loser_info = blue_info
      elsif winner == "blue"
        winner_name = blue
        winner_info = blue_info
        loser_name = red
        loser_info = red_info
      end
      Match.transaction do
        Match.create!(guid: guid, redname1: red[0], redname2: red[1], bluename1: blue[0], bluename2: blue[1], redscore: score_red, bluescore: score_blue, winner1: winner_name[0], winner2: winner_name[1], hopping_allowed: hopping_allowed, game_double: game_double, game_ex_speed: game_ex_speed, game_boundaries: game_boundaries, score_max: score_max, is_single: is_single, season_id: season.id)
        if is_single
          w = season.users.find_by(user_info: winner_info[0])
          l = season.users.find_by(user_info: loser_info[0])
          # ルール毎に入力変更
          if game_boundaries && game_double
            w.ow_d_win += 1
            w.ow_d_rate += rate[0]
            l.ow_d_lose += 1
            l.ow_d_rate -= rate[1]
          elsif game_boundaries && !game_double
            w.ow_s_win += 1
            w.ow_s_rate += rate[0]
            l.ow_s_lose += 1
            l.ow_s_rate -= rate[1]
          elsif !game_boundaries && game_double
            w.nw_d_win += 1
            w.nw_d_rate += rate[0]
            l.nw_d_lose += 1
            l.nw_d_rate -= rate[1]
          elsif !game_boundaries && !game_double
            w.nw_s_win += 1
            w.nw_s_rate += rate[0]
            l.nw_s_lose += 1
            l.nw_s_rate -= rate[1]
          end
          w.save!
          l.save!
        end
      end
    end
    render json: { result:"success" }
  end

  def gettop
    data = {}
    season = params[:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season])
    # 壁なしシングルTOP5取得
    nw_s = season.users.select(:name, :nw_s_rate, :nw_s_win, :nw_s_lose).where.not(nw_s_win: 0, nw_s_lose: 0).order(nw_s_rate: :desc, nw_s_win: :desc, updated_at: :asc).limit(5)
    data.store("nw_s", nw_s.to_json)
    # 壁なしダブル取得
    nw_d = season.users.select(:name, :nw_d_rate, :nw_d_win, :nw_d_lose).where.not(nw_d_win: 0, nw_d_lose: 0).order(nw_d_rate: :desc, nw_d_win: :desc, updated_at: :asc).limit(5)
    data.store("nw_d", nw_d.to_json)
    # 壁ありシングル取得
    ow_s = season.users.select(:name, :ow_s_rate, :ow_s_win, :ow_s_lose).where.not(ow_s_win: 0, ow_s_lose: 0).order(ow_s_rate: :desc, ow_s_win: :desc, updated_at: :asc).limit(5)
    data.store("ow_s", ow_s.to_json)
    # 壁ありダブル取得
    ow_d = season.users.select(:name, :ow_d_rate, :ow_d_win, :ow_d_lose).where.not(ow_d_win: 0, ow_d_lose: 0).order(ow_d_rate: :desc, ow_d_win: :desc, updated_at: :asc).limit(5)
    data.store("ow_d", ow_d.to_json)
    render json: data.to_json
  end

  def getrank
    season = params[:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season])
    data = season.users.select(:name, :nw_s_rate, :nw_s_win, :nw_s_lose).where.not(nw_s_win: 0, nw_s_lose: 0, nw_d_win: 0, nw_d_lose: 0 ,ow_s_win: 0, ow_s_lose: 0, ow_d_win: 0, ow_d_lose: 0)
    render json: data.to_json
  end
end
