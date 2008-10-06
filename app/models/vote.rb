class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :link
  
  validates_presence_of :user
  validates_presence_of :link
  validates_uniqueness_of :user_id, :scope => :link_id
end
