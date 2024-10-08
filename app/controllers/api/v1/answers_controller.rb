class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :answer, except: :create
  before_action :question, only: :create

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_resource_owner

    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: answer, status: :ok
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
