# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionUpdateNotificationService do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, user: user, subscribable: question) }
  let(:answer) { create(:answer, question: question) }

  before do
    Answer.skip_callback(:create, :after, :notify_subscribers)
  end

  after do
    Answer.set_callback(:create, :after, :send_notification)
  end

  it 'sends notification for subscribers' do
    users = User.all
    users.each do |user|
      expect(QuestionUpdateMailer)
        .to receive(:send_notification)
        .with(user, answer)
        .and_call_original
    end

    QuestionUpdateNotificationService.new(answer).call
  end
end
