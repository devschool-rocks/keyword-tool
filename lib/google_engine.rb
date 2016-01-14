module GoogleEngine
  extend self

  def rank(keyword)
    find_rankings(keyword)
  end

private

  def find_rankings(keyword)
    search = Google::Search::Web.new do |search|
      search.query = keyword
      search.size = :large
    end
    search.map do |item|
      { url: item.uri, position: item.index+1 }
    end
  end

end
