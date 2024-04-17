module ApiHelper
  # シングルス用レート計算関数
  def GetRate(winner_rate, winner_score, loser_rate, loser_score, score_max)
    # １点マッチの場合レート変動なし
    if score_max == "1"
      return {win: 0, lose: 0}
    end
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

  def TopData(season)
    data = {}
    nw_s = season.users.select("name, nw_s_rate as rate, nw_s_win as win, nw_s_lose as lose, id").where.not(nw_s_win: 0, nw_s_lose: 0).order(nw_s_rate: :desc, nw_s_win: :desc, updated_at: :asc).limit(10)
    for i in 1..10
      if nw_s.size < i
        break;
      end
      if i == 1
        data[:nowall_single] = {i.to_s.to_sym=> nw_s[i - 1]}
      else
        data[:nowall_single][i.to_s.to_sym] = nw_s[i - 1]
      end
      data[:nowall_single][i.to_s.to_sym][:rate] =  data[:nowall_single][i.to_s.to_sym][:rate].to_s
      data[:nowall_single][i.to_s.to_sym][:win] =  data[:nowall_single][i.to_s.to_sym][:win].to_s
      data[:nowall_single][i.to_s.to_sym][:lose] =  data[:nowall_single][i.to_s.to_sym][:lose].to_s
      data[:nowall_single][i.to_s.to_sym][:id] =  data[:nowall_single][i.to_s.to_sym][:id].to_s
    end
    # 壁なしダブル取得
    nw_d = season.users.select("name, nw_d_rate as rate, nw_d_win as win, nw_d_lose as lose, id").where.not(nw_d_win: 0, nw_d_lose: 0).order(nw_d_rate: :desc, nw_d_win: :desc, updated_at: :asc).limit(10)
    for i in 1..10
      if nw_d.size < i
        break;
      end
      if i == 1
        data[:nowall_double] = {i.to_s.to_sym=> nw_d[i - 1]}
      else
        data[:nowall_double][i.to_s.to_sym] = nw_d[i - 1]
      end
      data[:nowall_double][i.to_s.to_sym][:rate] =  data[:nowall_double][i.to_s.to_sym][:rate].to_s
      data[:nowall_double][i.to_s.to_sym][:win] =  data[:nowall_double][i.to_s.to_sym][:win].to_s
      data[:nowall_double][i.to_s.to_sym][:lose] =  data[:nowall_double][i.to_s.to_sym][:lose].to_s
      data[:nowall_double][i.to_s.to_sym][:id] =  data[:nowall_double][i.to_s.to_sym][:id].to_s
    end
    # 壁ありシングル取得
    ow_s = season.users.select("name, ow_s_rate as rate, ow_s_win as win, ow_s_lose as lose, id").where.not(ow_s_win: 0, ow_s_lose: 0).order(ow_s_rate: :desc, ow_s_win: :desc, updated_at: :asc).limit(10)
    for i in 1..10
      if ow_s.size < i
        break;
      end
      if i == 1
        data[:onwall_single] = {i.to_s.to_sym=> ow_s[i - 1]}
      else
        data[:onwall_single][i.to_s.to_sym] = ow_s[i - 1]
      end
      data[:onwall_single][i.to_s.to_sym][:rate] =  data[:onwall_single][i.to_s.to_sym][:rate].to_s
      data[:onwall_single][i.to_s.to_sym][:win] =  data[:onwall_single][i.to_s.to_sym][:win].to_s
      data[:onwall_single][i.to_s.to_sym][:lose] =  data[:onwall_single][i.to_s.to_sym][:lose].to_s
      data[:onwall_single][i.to_s.to_sym][:id] =  data[:onwall_single][i.to_s.to_sym][:id].to_s
    end
    # 壁ありダブル取得
    ow_d = season.users.select("name, ow_d_rate as rate, ow_d_win as win, ow_d_lose as lose, id").where.not(ow_d_win: 0, ow_d_lose: 0).order(ow_d_rate: :desc, ow_d_win: :desc, updated_at: :asc).limit(10)
    for i in 1..10
      if ow_d.size < i
        break;
      end
      if i == 1
        data[:onwall_double] = {i.to_s.to_sym=> ow_d[i - 1]}
      else
        data[:onwall_double][i.to_s.to_sym] = ow_d[i - 1]
      end
      data[:onwall_double][i.to_s.to_sym][:rate] =  data[:onwall_double][i.to_s.to_sym][:rate].to_s
      data[:onwall_double][i.to_s.to_sym][:win] =  data[:onwall_double][i.to_s.to_sym][:win].to_s
      data[:onwall_double][i.to_s.to_sym][:lose] =  data[:onwall_double][i.to_s.to_sym][:lose].to_s
      data[:onwall_double][i.to_s.to_sym][:id] =  data[:onwall_double][i.to_s.to_sym][:id].to_s
    end
    # DMA取得
    dma = season.users.select("name, dma_rate as rate, dma_win as win, dma_lose as lose, id").where.not(dma_win: 0, dma_lose: 0).order(dma_rate: :desc, dma_win: :desc, updated_at: :asc).limit(10)
    for i in 1..10
      if ow_d.size < i
        break;
      end
      if i == 1
        data[:dma] = {i.to_s.to_sym=> dma[i - 1]}
      else
        data[:dma][i.to_s.to_sym] = dma[i - 1]
      end
      data[:dma][i.to_s.to_sym][:rate] =  data[:dma][i.to_s.to_sym][:rate].to_s
      data[:dma][i.to_s.to_sym][:win] =  data[:dma][i.to_s.to_sym][:win].to_s
      data[:dma][i.to_s.to_sym][:lose] =  data[:dma][i.to_s.to_sym][:lose].to_s
      data[:dma][i.to_s.to_sym][:id] =  data[:dma][i.to_s.to_sym][:id].to_s
    end
    return data
  end

  def RankData(season)
    value = season.users.select(:name, :nw_s_rate , :nw_s_win, :nw_s_lose, :nw_d_rate, :nw_d_win, :nw_d_lose, :ow_s_rate, :ow_s_win, :ow_s_lose, :ow_d_rate, :ow_d_win, :ow_d_lose, :dma_rate, :dma_win, :dma_lose, :id).where.not(nw_s_win: 0, nw_s_lose: 0, nw_d_win: 0, nw_d_lose: 0 ,ow_s_win: 0, ow_s_lose: 0, ow_d_win: 0, ow_d_lose: 0)
    data = []
    value.each do |v|
      data.append({:name => v.name, :nowall_single => {:rate => v.nw_s_rate.to_s, :win => v.nw_s_win.to_s, :lose => v.nw_s_lose.to_s}, :nowall_double => {:rate => v.nw_d_rate.to_s, :win => v.nw_d_win.to_s, :lose => v.nw_d_lose.to_s}, :onwall_single => {:rate => v.ow_s_rate.to_s, :win => v.ow_s_win.to_s, :lose => v.ow_s_lose.to_s}, :onwall_double => {:rate => v.ow_d_rate.to_s, :win => v.ow_d_win.to_s, :lose => v.ow_d_lose.to_s}, :dma => {:rate => v.dma_rate.to_s, :win => v.dma_win.to_s, :lose => v.dma_lose.to_s}})
    end
    return data
  end

  def StatusData(season)
    data = {}
    data[:season] = {:name => season.name, :id => season.id.to_s, :started_at => season.created_at, :finished_at => season.finished_at}
    data[:players] = {:nowall_single => season.users.where.not(nw_s_win: 0, nw_s_lose: 0).count().to_s,
                      :nowall_double => season.users.where.not(nw_d_win: 0, nw_d_lose: 0).count().to_s,
                      :onwall_single => season.users.where.not(ow_s_win: 0, ow_s_lose: 0).count().to_s,
                      :onwall_double => season.users.where.not(ow_d_win: 0, ow_d_lose: 0).count().to_s,
                      :dma => season.users.where.not(dma_win: 0, dma_lose: 0).count().to_s}
    data[:message] = season.message
    return data
  end
end
