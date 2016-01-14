desc 'update keywords rankings'
task "serps:update" => :environment do
  keywords = ['devschool', 'online coding bootcamp', 'coding bootcamp', 'online dev school',
              'web developer bootcamp', 'coding school', 'dev school', 'developer school']
  keywords.each do |kwd|
    Ranking.fetch(kwd)
  end
end
