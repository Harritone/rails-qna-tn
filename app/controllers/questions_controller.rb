class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new
    question.links.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def edit 
  end

  def update
    return unless current_user.author_of?(question)
    question.update(question_params)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
    redirect_to questions_path, notice: 'Question was removed'
    else
      flash[:alert] = 'You are not allowed to perform this action'
      redirect_to questions_path
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
