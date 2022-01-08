class QuestionUpdateMailer < ApplicationMailer
  def send_notification(user, answer)
    @question = answer.question

    mail to: user.email
  end
end
