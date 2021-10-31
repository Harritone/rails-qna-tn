require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validation of url' do
    let(:link) { build(:link) }
    let(:question) { create(:question) }

    before { link.linkable = question }

    it 'should return errors when url is invalid' do
      link.url = 'http:invalid.com'
      expect(link).not_to be_valid
      expect(link.errors[:url]).to include("is not a valid HTTP URL")
    end

    it 'should not reurn error when url is valid' do
      link.url = 'http://valid.com'
      expect(link).to be_valid
    end
  end
end
