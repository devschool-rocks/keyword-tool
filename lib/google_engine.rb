require 'open-uri'
module GoogleEngine
  extend self

  def rank(keyword)
    raise 'ok'
    find_rankings(keyword)
  end

private

  def find_rankings(keyword)
    url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyDcYekluq-PNiRYZ4zD2pm4OVNfrvtsYsE&cx=001772248512260181370:_y8o10nvm7m&q=#{URI.escape(keyword)}"
    puts open(url)
    #search.map do |item|
    #  { url: item.uri, position: item.index+1 }
    #end
  end

end
