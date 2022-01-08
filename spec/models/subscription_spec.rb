require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { build(:subscription, user: create(:user), subscribable: create(:question)) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :subscribable }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:subscribable_type, :subscribable_id) }
end
