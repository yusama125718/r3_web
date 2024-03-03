class ApiController < ApplicationController
  skip_forgery_protection

  # リザルト受け取り処理
  def create
    if Settings.api_key != params[:api_key] 
      return
    end
    season = Season.find_by(finished_at: nil)
    score_red = params[:score_a]
    score_blue = params[:score_b]
    guid = params[:guid]
    hopping_allowed = params[:hopping_allowed] == "on"
    game_double = params[:game_double] == "on"
    game_ex_speed = params[:game_ex_speed]
    game_boundaries = params[:game_boundaries] == "on"
    score_max = params[:score_max]
    winner = score_red == score_blue ? "none" : score_red > score_blue ? "red" : "blue" 
    # レート計算
    rate = winner == "red" ? score_red.to_i - score_blue.to_i : score_blue.to_i - score_red.to_i
    # シングルスかダブルスか判定
    is_single = (params[:name_a1] == "" || params[:name_a2] == "") && (params[:name_b1] == "" || params[:name_b2] == "") && (params[:name_a1] != "" || params[:name_a2] != "") && (params[:name_b1] != "" || params[:name_b2] != "")
    # シングルスだった場合[0]がblankにならないように代入
    if is_single
      red = params[:name_a2] == "" ? [params[:name_a1], ""] : [params[:name_a2], ""]
      blue = params[:name_b2] == "" ? [params[:name_b1], ""] : [params[:name_b2], ""]
      reddiff1 = winner == "none" ? 0 : winner == "red" ? rate + 1 : rate * -1
      reddiff2 = 0
      bluediff1 = winner == "none" ? 0 : winner == "blue" ? rate + 1 : rate * -1
      bluediff2 = 0
    else
      red = [params[:name_a1], params[:name_a2]]
      blue = [params[:name_b1], params[:name_b2]]
    end
    # ユーザーデータがなかったら作成
    if red[0] != ""
      red_info = [UserInfo.where(now_name: nil).find_by(name: red[0]), nil]
      if red_info[0].nil?
        red_info[0] = UserInfo.create!(name: red[0])
      end 
      reduser = [season.users.find_by(user_info: red_info[0]), nil]
      if reduser[0].nil?
        reduser[0] = User.create!(user_info: red_info[0], season_id: season.id)
      end
    end 
    if red[1] != ""
      red_info[1] = UserInfo.where(now_name: nil).find_by(name: red[0])
      if red_info[1].nil?
        red_info[1] = UserInfo.create!(name: red[0])
      end 
      reduser[1] = season.users.find_by(user_info: red_info[1])
      if reduser[1].nil?
        reduser[1] = User.create!(user_info: red_info[1], season_id: season.id)
      end
    end 
    if blue[0] != ""
      blue_info = [UserInfo.where(now_name: nil).find_by(name: blue[0]), nil]
      if blue_info[0].nil?
        blue_info[0] = UserInfo.create!(name: blue[0])
      end 
      blueuser = [season.users.find_by(user_info: blue_info[0]), nil]
      if blueuser[0].nil?
        blueuser[0] = User.create!(user_info: blue_info[0], season_id: season.id)
      end
    end 
    if blue[1] != ""
      blue_info[1] = UserInfo.where(now_name: nil).find_by(name: blue[0])
      if info.nil?
        blue_info[1] = UserInfo.create!(name: blue[0])
      end 
      blueuser[1] = season.users.find_by(user_info: blue_info[1])
      if blueuser[1].nil?
        blueuser[1] = User.create!(user_info: blue_info[1], season_id: season.id)
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
            w.ow_d_rate += rate + 1
            l.ow_d_lose += 1
            l.ow_d_rate -= rate
          elsif game_boundaries && !game_double
            w.ow_s_win += 1
            w.ow_s_rate += rate + 1
            l.ow_s_lose += 1
            l.ow_s_rate -= rate
          elsif !game_boundaries && game_double
            w.nw_d_win += 1
            w.nw_d_rate += rate + 1
            l.nw_d_lose += 1
            l.nw_d_rate -= rate
          elsif !game_boundaries && !game_double
            w.nw_s_win += 1
            w.nw_s_rate += rate + 1
            l.nw_s_lose += 1
            l.nw_s_rate -= rate
          else
            w.other_win += 1
            w.other_rate += rate + 1
            l.other_lose += 1
            l.other_rate -= rate
          end
          w.save!
          l.save!
        else
          if !winner_name[0].blank?
            w = season.users.find_by(user_info: winner_info[0])
            w.other_win += 1
            w.other_rate += rate
            w.save!
          end
          if !winner_name[1].blank?
            w = season.users.find_by(user_info: winner_info[1])
            w.other_win += 1
            w.other_rate += rate
            w.save!
          end
          if !loser_name[0].blank?
            l = season.users.find_by(user_info: loser_info[0])
            l.other_lose += 1
            l.other_rate -= rate
            l.save!
          end
          if !loser_name[1].blank?
            l = season.users.find_by(user_info: loser_info[1])
            l.other_lose += 1
            l.other_rate -= rate
            l.save!
          end
        end
      end
    end
  end
end
