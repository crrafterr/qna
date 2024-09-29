class QuestionSerializer < ActiveModel::Serializer
  include AttachedConcern
  include CommentedConcern
  include LinkedConcern

  attributes :id, :title, :body, :created_at, :updated_at, :user_id
end
