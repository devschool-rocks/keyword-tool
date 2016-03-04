class Ranking < ActiveRecord::Base

  belongs_to :domain
  belongs_to :keyword
  has_many :page_factors

  scope :by_domain, -> (val) {
    with_domains.where("domains.value = ?", val)
  }

  scope :by_keyword, -> (val) {
    with_keywords.where("keywords.value = ?", val)
  }

  scope :with_best, -> {
    select("rankings.*, MAX(position) as best").
      group("rankings.id")
  }

  scope :with_domains, -> {
    joins(:domain)
  }

  scope :with_keywords, -> {
    joins(:keyword)
  }

  scope :track_domains, ->(*domains) {
    with_domains.
      where("domains.value IN (?)", domains)
  }

  def self.rankings_pivot(*domains)
    us   = 'devschool.rocks'
    them = domains-[us]
    data = Ranking.with_best.track_domains(*domains)
    keywords = data.map{|r| r.keyword.value}.uniq

    keywords.map do |kw|
      our = data.select {|r| r.domain.value  == us &&
                             r.keyword.value == kw}[0]
      theirs = data.select do |row|
        them.include?(row.domain.value) && row.keyword.value == kw
      end

      byebug
      theirs.reduce({}) {|acc, row| acc[row.domain.value] = [row.position] }

      RankingRow.new(
        keyword: kw,
        position: our.position,
        competition: theirs,
        page: our.url,
        best: our.best
      )
    end
  end

  class RankingRow < Struct.new(:keyword, :position, :competitors,
                                :competition, :page, :best)

    attr_reader :keyword, :position,
                :competition, :page, :best

    def initialize(attrs)
      attrs.each {|k,v| instance_variable_set("@#{k}", v) }
    end

  end

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
