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
    users = User.select { |u| u.votes.id }.to_a

    links.map do |link|
      link.probability = bayes(
        link,
        users_with_link(link, users),
        proc{|e, h| common_links(e, user, h) / all_links(e, user, h) },
        proc{|e| e.votes.size.to_f / links.size },
        proc{|h| h.votes.size.to_f / users.size })
      link
    end
  end

  private

  def self.all_links(lhs, rhs, link)
    (lhs.votes.map(&:link_id) | rhs.votes.map(&:link_id) | [link.id]).size
  end

  def self.common_links(lhs, rhs, link)
    (lhs.votes.map(&:link_id) & (rhs.votes.map(&:link_id) | [link.id])).size.to_f
  end

  # Avoids an N+1 situation.
  # This is equivalent to link.users, except it uses a pre-existing list so their
  # associations can be eager-loaded.
  def self.users_with_link(link, users)
    user_ids = link.votes.map(&:user_id)
    users.select{|u| user_ids.include? u.id }
  end

  def self.bayes(hypothesis, evidence, conditional, marginal, prior)
    evidence.map do |e|
      conditional[e, hypothesis]/marginal[e]
    end.inject(prior[hypothesis], &:*)
  end
end

