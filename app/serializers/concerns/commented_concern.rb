module CommentedConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    has_many :comments
  end

  def comments
    object.comments.map do |comment|
      { id: comment.id,
        body: comment.body,
        user_id: comment.user_id,
        created_at: comment.created_at,
        updated_at: comment.updated_at }
    end
  end
end
