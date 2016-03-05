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

  scope :impute_missing, -> {
    self
  }

  def self.fetch(keyword, domain)
    search  = Google::Search::Web.new do |search|
      search.query = keyword
      search.size = :large
    end

    search.map do |serp|
      next unless domain_from_url(serp.uri) == domain
      d = Domain.find_or_create_by(value: domain_from_url(serp.uri))
      record_ranking_and_page_factors(d, keyword, serp)
    end.compact
  end


private

  def self.domain_from_url(uri)
    uri.gsub(/(https?\:)?\/\//,'').split("/")[0]
  end

  def self.record_ranking_and_page_factors(domain, keyword, serp)
    ranking = Keyword.find_or_create_by(value: keyword).
      rankings.create(domain: domain, url: serp.uri, position: serp.index+1)
    ranking.page_factors.create(PageFactor.extract_factors(serp.uri))
    ranking
  end

end
