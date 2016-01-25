class Serp < ActiveRecord::Base
  def change
    change = yesterday.to_i - position.to_i
    (change + position.to_i).zero? ? nil : "(#{change})"
  end
end
