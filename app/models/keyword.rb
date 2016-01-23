class Keyword < ActiveRecord::Base
  has_many :rankings, dependent: :destroy
end
