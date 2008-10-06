class Link < ActiveRecord::Base
  has_many :votes
  has_many :users, :through => :votes
  belongs_to :creator, :class_name => "User"
end
