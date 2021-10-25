class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params.merge(user_id: current_user.id))

    # if @answer.save
    #   redirect_to question, notice: 'Answer was published.'
    # else
    #   render 'questions/show'
    # end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:alert] = 'Answer was removed'
    else
      flash[:alert] = 'You are not allowed to perform this action'
    end

    redirect_to @answer.question
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
