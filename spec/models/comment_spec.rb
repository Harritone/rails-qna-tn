require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  it { should validate_length_of(:content).is_at_least(5).is_at_most(10_000) }

  it 'should queue broadcast job when created' do
    ActiveJob::Base.queue_adapter = :test
    user = create(:user)
    question = create(:question, user: user)
    expect { create(:comment, commentable: question, user: user) }.to have_enqueued_job(CommentsBroadcastJob)
  end
end
