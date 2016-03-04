class RankingsController < ApplicationController
  def index
    @rankings = filter(
      Ranking.joins(:keyword, :domain)
    ).group("keywords.value").
      group_by_day("rankings.created_at").
      maximum(:position)
  end

private

  def filter(r)
    q = params[:domain_id] ? params[:domain_id] : params[:id]
    by_domain = r.where("domains.value = ?", q)
    return by_domain unless params[:domain_id]
    by_domain.where("keywords.value = ?", params[:id])
  end

end
