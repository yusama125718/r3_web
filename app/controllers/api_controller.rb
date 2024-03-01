class ApiController < ApplicationController
  skip_forgery_protection

  def create
    if !params.key?(:name_a1) || !params.key?(:name_a2) || !params.key?(:name_b1) || !params.key?(:name_b2) || !params.key?(:score_a) || !params.key?(:score_b) || !params.key?(:guid)
      return
    end
    red = [params[:name_a1], params[:name_a2]]
    blue = [params[:name_b1], params[:name_b2]]
    score_red = params[:score_a]
    score_blue = params[:score_b]
    guid = params[:guid]
    hopping_allowed = params[:hopping_allowed] == "on"
    game_double = params[:game_double] == "on"
    game_ex_speed = params[:game_ex_speed]
    game_boundaries = params[:game_boundaries] == "on"
    score_max = params[:score_max]
    winner = score_red == score_blue ? "none" : score_red > score_blue ? "red" : "blue" 
    if red[0] != "" && !User.exists?(name: red[0])
      User.create(name: red[0], single_win: 0, single_lose: 0, double_win: 0, double_lose: 0)
    end
    if red[1] != "" && !User.exists?(name: red[1])
      User.create(name: red[1], single_win: 0, single_lose: 0, double_win: 0, double_lose: 0)
    end
    if blue[0] != "" && !User.exists?(name: blue[0])
      User.create(name: blue[0], single_win: 0, single_lose: 0, double_win: 0, double_lose: 0)
    end
    if blue[1] != "" && !User.exists?(name: blue[1])
      User.create(name: blue[1], single_win: 0, single_lose: 0, double_win: 0, double_lose: 0)
    end
    if (red[0] == "" || red[1] == "") && (blue[0] == "" || blue[1] == "") && (red[0] != "" || red[1] != "") && (blue[0] != "" || blue[1] != "")
      # シングルス
      if !Single.exists?(guid: guid)
        winner_name = winner == "red" ? red[0] ? red[0] : red[1] : winner == "blue" ? blue[0] ? blue[0] : blue[1] : ""
        loser_name = winner == "red" ? blue[0] ? blue[0] : blue[1] : winner == "blue" ? red[0] ? red[0] : red[1] : ""
        Single.create(redname: red[0] ? red[0] : red[1], bluename: blue[0] ? blue[0] : blue[1], redscore: score_red, bluescore: score_blue, winner: winner, hopping_allowed: hopping_allowed, game_double: game_double, game_ex_speed: game_ex_speed, game_boundaries: game_boundaries, score_max: score_max)
        if winner != "none"
          w = User.find_by(name: winner_name)
          w.single_win += 1
          w.save
          l = User.find_by(name: loser_name)
          l.single_lose += 1
          l.save
        end
      end
    else
      # ダブルス
      if !Double.exists?(guid: guid)
        winner_name = winner == "red" ? [red[0], red[1]] : winner == "blue" ? [blue[0], blue[1]] : ""
        loser_name = winner == "red" ? [blue[0], blue[1]] : winner == "blue" ? [red[0], red[1]] : ""
        Double.create(redname1: red[0], redname2: red[1], bluename1: blue[0], bluename2: blue[1], redscore: score_red, bluescore: score_blue, winner1: winner_name[0], winner2: winner_name[1], hopping_allowed: hopping_allowed, game_double: game_double, game_ex_speed: game_ex_speed, game_boundaries: game_boundaries, score_max: score_max)
        if winner != "none"
          w = User.find_by(name: winner_name[0])
          w.double_win += 1
          w.save
          w = User.find_by(name: winner_name[1])
          w.double_win += 1
          w.save
          l = User.find_by(name: loser_name[0])
          l.double_lose += 1
          l.save
          l = User.find_by(name: loser_name[1])
          l.double_lose += 1
          l.save
        end
      end
    end
  end
end
