class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: :create
  before_action :find_answer,   only: %i[update destroy]
  authorize_resource

  def index
    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer
  end

  def create
    answer = @question.answers.build(answer_params.merge(user: current_user))

    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    head :ok if @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
