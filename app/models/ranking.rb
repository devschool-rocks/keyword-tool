class Ranking < ActiveRecord::Base

  belongs_to :domain
  belongs_to :keyword

  scope :with_best, -> {
    select("rankings.*, MAX(position) as best").
      group("rankings.id")
  }

  scope :with_domains, -> {
    joins("LEFT JOIN domains ON domains.id = rankings.domain_id")
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

  def self.fetch(keyword)
    search  = Google::Search::Web.new do |search|
      search.query = keyword
      search.size = :large
    end

    search.map do |serp|
      domain = Domain.find_or_create_by(value: domain_from_url(serp.uri))
      Keyword.find_or_create_by(value: keyword).rankings.
              create(domain: domain, url: serp.uri, position: serp.index+1)
    end
  end

private

  def self.domain_from_url(uri)
    uri.gsub(/(https?\:)?\/\//,'').split("/")[0]
  end

end
