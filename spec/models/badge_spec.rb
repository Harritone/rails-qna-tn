require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional(true) }

  it { should validate_presence_of :name}
  it { should validate_attached_of :image}
  it { should validate_content_type_of(:image).allowing('image/png', 'image/jpeg', 'image/jpg')  }

  it 'has one attached image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
