class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new; end

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
      render :edit
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
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
