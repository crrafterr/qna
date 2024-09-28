class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  after_action :publish_answer, only: :create

  authorize_resource

  def create
    @answer = question.answers.create(answer_params)
    @answer.user = current_user
    flash[:notice] = "Your answer successfully created." if @answer.save
  end

  def destroy
    answer.destroy
    flash[:notice] = "Answer successfully deleted."
    redirect_to @answer.question
  end

  def update
    answer.update(answer_params)
    @question = @answer.question
  end

  def best
    if current_user
      answer.best!
      answer.user.add_badge!(answer.question.badge)
    else
      redirect_to answer.question
    end
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  helper_method :question

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [ :name, :url ])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@answer.question_id}_answers", {
        answer: @answer,
        files: @answer.files_info,
        links: @answer.links,
        total_votes: @answer.total_votes
      }.to_json
    )
  end
end
