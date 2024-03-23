module ApiHelper
  # シングルス用レート計算関数
  def GetRate(winner_rate, winner_score, loser_rate, loser_score, score_max)
    # 敗者のレートによって勝利ポイントの減り幅の倍率を変える
    case loser_rate
    when nil..149
      level = 0.0
    when 150..449
      level = 0.2
    when 450..749
      level = 0.4
    when 750..1049
      level = 0.6
    when 1050..1249
      level = 0.8
    when 1250..nil
      level = 1.0
    end
    # レート差によって分岐
    rate_diff = winner_rate - loser_rate
    case rate_diff
    when 101..nil
      win = (20.0 * (-(1.0 / 100000.0) * ((rate_diff.to_f - 100.0) ** 2.0) + 1.0)).round
      lose = (20.0 * (-(1.0 / 100000.0) * ((rate_diff.to_f - 100.0) ** 2.0) + 1.0) * level).round
    when -100..100
      win = 20
      lose = (20.0 * level).round
    when -101..-499
      win = (-20.0 * (0.0025 * rate_diff.to_f + 0.75)).round
      lose = (20.0 * (-(1.0 / 100000.0) * ((rate_diff.to_f - 100.0) ** 2.0) + 1.0) * level).round
    when nil..-500
      win = 20 * 2 
      lose = 0
    end
    if win < 0
      win = 0
    end
    if lose < 0
      lose = 0
    end
    return {win: win, lose: lose}
  end
end
