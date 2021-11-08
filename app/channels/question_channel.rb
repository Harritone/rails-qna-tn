class QuestionChannel < ApplicationCable::Channel
  # def hello(data)
  #   Rails.logger.info data
  # end

  # def echo(data)
  #   transmit data
  # end

  def follow
    stream_from "questions"
  end
end
