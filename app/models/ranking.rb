require 'open-uri'
class Ranking < ActiveRecord::Base

  belongs_to :domain
  belongs_to :keyword
  has_many :page_factors

  scope :by_domain, ->(val) {
    with_domains.
      where("domains.value = ?", val)
  }

  scope :by_keyword, ->(val) {
    with_keywords.
      where("keywords.value = ?", val)
  }
  scope :with_domains, -> {
    joins(:domain)
  }

  scope :with_keywords, -> {
    joins(:keyword)
  }

  scope :with_data, -> {
    with_domains.with_keywords
  }

  scope :daily, -> {
    with_data.
      group("keywords.value").
      group_by_day("rankings.created_at").
      minimum(:position)
  }

  def self.fetch(keyword, domain)
    url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyDcYekluq-PNiRYZ4zD2pm4OVNfrvtsYsE&cx=001772248512260181370:_y8o10nvm7m&q=#{URI.escape(keyword)}"
    search = JSON.parse(open(url).read)["items"]

    search.map.with_index do |serp, i|
      next unless domain_from_url(serp['link']) == domain
      d = Domain.find_or_create_by(value: domain_from_url(serp['link']))
      record_ranking_and_page_factors(d, keyword, serp, i)
    end.compact
  end


private

  def self.domain_from_url(uri)
    uri.gsub(/(https?\:)?\/\//,'').split("/")[0]
  end

  def self.record_ranking_and_page_factors(domain, keyword, serp, i)
    ranking = Keyword.find_or_create_by(value: keyword).
      rankings.create(domain: domain, url: serp['link'], position: i+1)
    ranking.page_factors.create(PageFactor.extract_factors(serp['link']))
    ranking
  end

end
