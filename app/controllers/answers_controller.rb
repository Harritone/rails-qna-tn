class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    if current_user.author_of?(answer)
      @answer = answer
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    return unless current_user.author_of?(answer)

    @question = answer.question
    answer.destroy
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer
  helper_method :question

  def question
    Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
