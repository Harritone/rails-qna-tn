require 'rails_helper'

RSpec.describe QuestionUpdateNotificationJob, type: :job do
  let(:service) { double('QuestionUpdateNotificationService') }
  let(:answer) { create(:answer) }

  before do
    Answer.skip_callback(:create, :after, :notify_subscribers)

    allow(QuestionUpdateNotificationService)
      .to receive(:new)
      .and_return(service)
  end

  after do
    Answer.set_callback(:create, :after, :send_notification)
  end
  it 'calls QuestionUpdateNotificationService' do
    expect(service).to receive(:call)
    QuestionUpdateNotificationJob.perform_now(answer)
  end
end
