class User < ActiveRecord::Base
  has_many :votes
  has_many :links, :through => :votes
  has_many :created, :class_name => "Link", :foreign_key => "creator_id"
end
