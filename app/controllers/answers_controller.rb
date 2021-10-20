class AnswersController < ApplicationController
  expose :answer
  expose :question

  def create
    answer = question.answers.build(answer_params)
    if answer.save
      redirect_to answer.question
    else
      render :new
    end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
