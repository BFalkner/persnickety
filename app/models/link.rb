class Link < ActiveRecord::Base
  has_many :votes
  has_many :users, :through => :votes
  belongs_to :creator, :class_name => "User"

  validates_presence_of :title
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_presence_of :creator
end
