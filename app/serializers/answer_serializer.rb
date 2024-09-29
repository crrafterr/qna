class AnswerSerializer < ActiveModel::Serializer
  include AttachedConcern
  include CommentedConcern
  include LinkedConcern

  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at, :best
end
