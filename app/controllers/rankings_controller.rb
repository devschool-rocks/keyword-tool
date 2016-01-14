class RankingsController < ApplicationController
  def index
    @rankings = Ranking.rankings_pivot(
      "devschool.rocks",
      "www.thinkful.com",
      "www.bloc.io",
      "www.codingdojo.com")

  end
end
