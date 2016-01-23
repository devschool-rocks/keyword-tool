class Serp < ActiveRecord::Base
  def change
    change = yesterday.to_i - position
    (change + position).zero? ? nil : "(#{change})"
  end
end
