class ApiController < ApplicationController
  include ApiHelper
  skip_forgery_protection

  # リザルト受け取り処理
  def create
    if Settings.api_key != params[:api_key] 
      render  'errors/404', status: :not_found
      return
    end
    # NPCがいる場合弾く
    if params[:name_a1].start_with?("NPC ") || params[:name_a2].start_with?("NPC ") || params[:name_b1].start_with?("NPC ") || params[:name_b2].start_with?("NPC ") || params[:name_a1].start_with?("AI ") || params[:name_a2].start_with?("AI ") || params[:name_b1].start_with?("AI ") || params[:name_b2].start_with?("AI ")
      render json: { result: "CPU戦なので記録出来ませんでした。", status: "faild"}
      return
    end
    season = Season.find_by(finished_at: nil)
    # シングルスかダブルスか判定
    is_single = (params[:name_a1] == "" || params[:name_a2] == "") && (params[:name_b1] == "" || params[:name_b2] == "") && (params[:name_a1] != "" || params[:name_a2] != "") && (params[:name_b1] != "" || params[:name_b2] != "")
    # シングルスだった場合[0]がblankにならないように代入
    if is_single
      red = params[:name_a2] == "" ? [params[:name_a1], ""] : [params[:name_a2], ""]
      blue = params[:name_b2] == "" ? [params[:name_b1], ""] : [params[:name_b2], ""]
    else
      render json: { result: "シングルスでないので記録出来ませんでした。", status: "faild"}
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
    dma = params[:dma] == "on"
    score_red = params[:score_a].to_i
    score_blue = params[:score_b].to_i
    guid = params[:guid]
    hopping_allowed = params[:hopping_allowed] == "on"
    game_double = params[:game_double] == "on"
    game_ex_speed = params[:game_ex_speed]
    game_boundaries = params[:game_boundaries] == "on"
    score_max = params[:score_max]
    # 同点だったら記録しない
    if score_red == score_blue
      render json: { result: "同点なので記録できませんでした", status: "faild"}
      return
    end
    # シングルス専用レート計算処理
    if score_red > score_blue
      winner = "red"
      if game_boundaries && game_double
        rate = GetRate(reduser[0].ow_d_rate, score_red, blueuser[0].ow_d_rate, score_blue, score_max)
      elsif game_boundaries && !game_double
        rate = GetRate(reduser[0].ow_s_rate, score_red, blueuser[0].ow_s_rate, score_blue, score_max)
      elsif !game_boundaries && game_double
        rate = GetRate(reduser[0].nw_d_rate, score_red, blueuser[0].nw_d_rate, score_blue, score_max)
      elsif !game_boundaries && !game_double
        rate = GetRate(reduser[0].nw_s_rate, score_red, blueuser[0].nw_s_rate, score_blue, score_max)
      end
    else
      winner = "blue"
      if game_boundaries && game_double
        rate = GetRate(blueuser[0].ow_d_rate, score_blue, reduser[0].ow_d_rate, score_red, score_max)
      elsif game_boundaries && !game_double
        rate = GetRate(blueuser[0].ow_s_rate, score_blue, reduser[0].ow_s_rate, score_red, score_max)
      elsif !game_boundaries && game_double
        rate = GetRate(blueuser[0].nw_d_rate, score_blue, reduser[0].nw_d_rate, score_red, score_max)
      elsif !game_boundaries && !game_double
        rate = GetRate(blueuser[0].nw_s_rate, score_blue, reduser[0].nw_s_rate, score_red, score_max)
      end
    end
    # guidのかぶりがなかったら試合結果を追加
    if !season.matches.exists?(guid: guid)
      if winner == "red"
        winner_name = red
        winner_info = red_info
        red_diff = "+" + rate[:win].to_s
        loser_name = blue
        loser_info = blue_info
        blue_diff = "-" + rate[:lose].to_s
      elsif winner == "blue"
        winner_name = blue
        winner_info = blue_info
        blue_diff = "+" + rate[:win].to_s
        loser_name = red
        loser_info = red_info
        red_diff = "-" + rate[:lose].to_s
      end
      Match.transaction do
        Match.create!(guid: guid, redname1: red[0], redname2: red[1], bluename1: blue[0], bluename2: blue[1], redscore: score_red, bluescore: score_blue, winner1: winner_name[0], winner2: winner_name[1], hopping_allowed: hopping_allowed, game_double: game_double, game_ex_speed: game_ex_speed, game_boundaries: game_boundaries, score_max: score_max, is_single: is_single, season_id: season.id, reddiff1: red_diff, bluediff1: blue_diff, dma: dma)
        if is_single
          if winner == "red"
            w = reduser[0]
            l = blueuser[0]
          elsif winner == "blue"
            w = blueuser[0]
            l = reduser[0]
          end
          # ルール毎に入力変更
          if game_boundaries && game_double
            w.ow_d_win += 1
            w.ow_d_rate += rate[:win]
            if w.ow_d_rate > Settings.rate_max
              w.ow_d_rate = 9999
            end
            l.ow_d_lose += 1
            l.ow_d_rate -= rate[:lose]
            if l.ow_d_rate < Settings.rate_min
              l.ow_d_rate = 0
            end
          elsif game_boundaries && !game_double
            w.ow_s_win += 1
            w.ow_s_rate += rate[:win]
            if w.ow_s_rate > Settings.rate_max
              w.ow_s_rate = 9999
            end
            l.ow_s_lose += 1
            l.ow_s_rate -= rate[:lose]
            if l.ow_s_rate < Settings.rate_min
              l.ow_s_rate = 0
            end
          elsif !game_boundaries && game_double
            w.nw_d_win += 1
            w.nw_d_rate += rate[:win]
            if w.nw_d_rate > Settings.rate_max
              w.nw_d_rate = 9999
            end
            l.nw_d_lose += 1
            l.nw_d_rate -= rate[:lose]
            if l.nw_s_rate < Settings.rate_min
              l.nw_s_rate = 0
            end
          elsif !game_boundaries && !game_double
            w.nw_s_win += 1
            w.nw_s_rate += rate[:win]
            if w.nw_s_rate > Settings.rate_max
              w.nw_s_rate = 9999
            end
            l.nw_s_lose += 1
            l.nw_s_rate -= rate[:lose]
            if w.nw_s_rate > Settings.rate_max
              w.nw_s_rate = 9999
            end
          end
          # dmaだった場合追加で処理する
          if dma
            if score_red > score_blue
              rate = GetRate(reduser[0].dma_rate, score_red, blueuser[0].dma_rate, score_blue, score_max)
            else
              rate = GetRate(blueuser[0].dma_rate, score_blue, reduser[0].dma_rate, score_red, score_max)
            end
            w.dma_win += 1
            l.dma_lose += 1
            w.dma_rate += rate[:win]
            l.dma_rate -= rate[:lose]
          end
          if w.save && l.save
            render json: { result: "保存しました", status: "success"}
            return
          else 
            render json: { result: "保存に失敗しました", status: "faild"}
            return
          end
        end
      end
    end
  end

  def gettop
    data = {}
    data[:api_ver] = Settings.api_ver
    season = params[:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season])
    data[:season] = season.name
    # 壁なしシングルTOP5取得
    data[:top] = TopData(season)
    render json: data.to_json
  end

  def getrank
    data = {}
    season = params[:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season])
    data[:rank] = RankData(season)
    data[:api_ver] = Settings.api_ver
    render json: data.to_json
  end

  def getstatus
    data = {}
    data[:api_ver] = Settings.api_ver
    season = params[:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season])
    data[:season] = StatusData(season)
    render json: data.to_json
  end

  def getutil
    data = {}
    data[:api_ver] = Settings.api_ver
    season = params[:season].blank? ? Season.find_by(finished_at: nil) : Season.find_by(id: params[:season])
    data[:season] = season.name
    data[:top] = TopData(season)
    data[:rank] = RankData(season)
    data[:status] = StatusData(season)
    render json: data.to_json
  end
end
