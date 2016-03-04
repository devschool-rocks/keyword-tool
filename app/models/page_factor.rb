class PageFactor < ActiveRecord::Base
  belongs_to :ranking

  def self.extract_factors(url)
    doc = Nokogiri::HTML(open(url).read)
    {
      title: doc.css("title").text,
      description: doc.at('meta[@name="description"]')[:content],
      h1: doc.css("h1").text
    }
  end
end
