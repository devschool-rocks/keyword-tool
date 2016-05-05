desc 'update keywords rankings'
task "serps:update" => :environment do
  Keyword.pluck(:value).each do |kwd|
    Ranking.fetch(kwd, "devschool.rocks")
  end
end
