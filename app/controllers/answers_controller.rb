class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  after_action :publish_answer, only: :create

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

  def mark_best
    @question = answer.question
    return unless current_user.author_of?(@question)

    @question.update(best_answer: answer)
    @question.badge&.update(user: answer.user)
  end

  private

  def publish_answer
    return if answer.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "warden" => warden })
    # renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:3000",
    #   "HTTPS"=>"off",
    #   "REQUEST_METHOD"=>"GET",
    #   "SCRIPT_NAME"=>"",
    #   "warden" => warden})

    ActionCable.server.broadcast "questions-#{answer.question_id}",
      renderer.render(
        partial: 'answers/answer',
        locals: { answer: answer }
      )
  end

  def answer
    @answer ||= params[:id] ? Answer.includes(:comments, :links, :votes).find(params[:id]) : Answer.new
  end

  helper_method :answer
  helper_method :question

  def question
    Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
