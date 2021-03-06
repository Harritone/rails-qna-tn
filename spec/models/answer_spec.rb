require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'

  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should accept_nested_attributes_for :links }

  it 'should have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'after_create notify_subscribers' do
    let(:answer) { build(:answer) }

    it 'should call QuestionUpdateNotificationJob' do
      expect(QuestionUpdateNotificationJob)
        .to receive(:perform_later)
        .with(answer.question)

      answer.save!
    end
  end
end
