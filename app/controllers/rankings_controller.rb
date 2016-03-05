class RankingsController < ApplicationController
  def index
    @rankings = filter(
      Ranking.impute_missing
    ).daily
  end

private

  def filter(r)
    q = params[:domain_id] ? params[:domain_id] : params[:id]
    by_domain = r.where("domains.value = ?", q)
    return by_domain unless params[:domain_id]
    by_domain.where("keywords.value = ?", params[:id])
  end

end
