module ApplicationHelper
  def caluclate_changes(rankings)
    kwds = rankings.reduce({}) { |h, (k, p)| (h[k[0]] ||= []) << p; h }
    kwds.map {|k|
      key = k[0].to_s
      min = k[1].min {|a,b| a <=> b }.to_i
      max = k[1].max {|a,b| a <=> b }.to_i
      { key => max - min }
    }.map {|h| key = h.keys[0] ;[key, h[key]] }
  end

  def ranking_ceiling(h)
    h.each_with_object({}) { |(k,v),g|
      g[k] = (Hash === v) ?  fifty_plus(v) : v.to_i == 0 ? 80 : v.to_i }
  end
end
