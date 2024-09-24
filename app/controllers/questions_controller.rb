class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :gon_question_id, only: [ :show, :create ]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    question.links.new
    question.badge ||= Badge.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "Your question was succesfully created"
    else
      render :new
    end
  end

  def update
    if current_user.author?(question)
      question.update(question_params)
    else
      render :show
    end
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: "Question successfully deleted."
    else
      redirect_to question, notice: "The question has not been deleted. You are not the author of the question."
    end
  end

  private

  def question
    @question ||= params[:id] ?  Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [ :name, :url ], badge_attributes: [ :title, :image ])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast("questions", question.to_json)
  end

  def gon_question_id
    gon.question_id = question.id
  end
end
