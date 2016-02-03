module ApplicationHelper
  def ranking_ceiling(h)
    h.each_with_object({}) { |(k,v),g|
      g[k] = (Hash === v) ?  fifty_plus(v) : v.to_i == 0 ? 80 : v.to_i }
  end
end
