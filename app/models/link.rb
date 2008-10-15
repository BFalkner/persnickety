class Link < ActiveRecord::Base
  has_many :votes
  has_many :users, :through => :votes
  belongs_to :creator, :class_name => "User"

  validates_presence_of :title
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_presence_of :creator_id

  attr_protected :creator_id

  attr_accessor :probability

  def self.find_by_probability(user)
    links = Link.find :all, :include => :votes
    users_size = User.select { |u| u.votes.id }.size
    user_links = links_from_user(user, links)

    links.each do |link|
      link.probability = bayes(
        link,
        user_links,
        proc{|e, h| common_users(e, h, user) / with_user(h, user) },
        proc{|e| 1 },
        proc{|h| h.votes.size.to_f / users_size })
    end
  end

  private

  def self.common_users(lhs, rhs, user)
    (lhs.votes.map(&:user_id) & (rhs.votes.map(&:user_id) | [user.id])).size.to_f
  end
  
  def self.with_user(link, user)
    (link.votes.map(&:user_id) | [user.id]).size
  end

  # Avoids an N+1 situation.
  # This is equivalent to user.links, except it uses a pre-existing list so their
  # associations can be eager-loaded.
  def self.links_from_user(user, links)
    link_ids = user.votes.map(&:link_id)
    links.select{|l| link_ids.include? l.id }
  end

  def self.bayes(hypothesis, evidence, conditional, marginal, prior)
    evidence.map do |e|
      conditional[e, hypothesis]/marginal[e]
    end.inject(prior[hypothesis], &:*)
  end
end

