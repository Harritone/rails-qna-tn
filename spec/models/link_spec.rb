require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link) { build(:link) }

  it { should belong_to(:linkable) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validation of url' do
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

  describe '#gist?' do
    it 'should return true if url include "gist.github.com"' do
      link.url = 'https://gist.github.com/Harritone/170e91c1ce800c34417bc4ede3926f2a'
      expect(link.gist?).to be true
    end

    it 'should return false if url not include "gist.github.com"' do
      link.url = 'https://google.com'
      expect(link.gist?).to be false
    end
  end
end
