class Vote < ActiveRecord::Base
  has_many :users
  has_many :votes
end
