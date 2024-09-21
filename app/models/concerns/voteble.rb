module Voteble
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteble, dependent: :destroy
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def total_votes
    votes.sum(:vote)
  end

  def recall(user)
    votes.find_by(user_id: user)&.destroy
  end

  private

  def vote(user, vote)
    votes.create!(user: user, vote: vote) unless user.voted?(self) || user.author?(self)
  end
end
