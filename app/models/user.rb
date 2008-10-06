class User < ActiveRecord::Base
  has_many :votes
  has_many :links, :through => :votes
  has_many :created, :class_name => "Link", :foreign_key => "creator_id"
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :name
  validates_presence_of :password_hash
  
  attr_protected :password_hash
end
