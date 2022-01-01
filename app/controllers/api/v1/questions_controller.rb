class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, except: :create
  authorize_resource

  def index
    render json: Question.all
  end

  def show
    render json: @question
  end

  def create
    question = Question.new(question_params.merge(user: current_user))

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    head :ok if @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id])
  end

  def find_question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end
end
