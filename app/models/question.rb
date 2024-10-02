class Question < ApplicationRecord
  include Voteble
  include Commenteble

  belongs_to :user
  has_one :badge, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :create_subscription

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def create_subscription
    subscriptions.create!(user: user)
  end
end
