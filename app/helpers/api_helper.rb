module ApiHelper
  # シングルス用レート計算関数
  def GetRate(winner_rate, winner_score, loser_rate, loser_score, score_max)
    rate_diff = winner_rate - loser_rate
    # 敗者のレートによって勝利ポイントの減り幅の倍率を変える
    case loser_rate
    when 0..299
      level = 0.5
    when 300..599
      level = 0.6
    when 600..899
      level = 0.7
    when 900..1199
      level = 0.8
    when 1200..1499
      level = 0.9
    when 1500..nil
      level = 1.0
    end
    # レート差によって分岐
    case rate_diff
    when -200..199
      win_point = score_max == "1" ? 2 : score_max == "5" ? 12 : 20
      score_point = (winner_score.to_f - loser_score.to_f) * 3.0
      win = win_point + score_point
      lose = win_point * level + score_point
    when 200..599
    end
  end
end
