class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: :create
  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
    @answer.links.build
    @comments = question.comments
    @comment = Comment.new
    gon.question_id = @question.id
  end

  def new
    question.links.build
    question.build_badge
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

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions',
    ApplicationController.render(
      partial: 'questions/collection',
      locals: { question: @question }
    )
  end

  def question
    @question ||= params[:id] ? Question.includes(:comments, :links, :votes).with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     badge_attributes: [:name, :image, :_destroy])
  end
end
