# frozen_string_literal: true

# DailyDigestMailer responsible for sending newly created questions for the last day.
class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @daily_questions = Questions.where(crteated_at: (Time.now.midnight - 1.day)..Time.now.midnight)

    mail to: user.email
  end
end
