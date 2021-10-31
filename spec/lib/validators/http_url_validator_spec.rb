require 'rails_helper'

RSpec.describe HttpUrlValidator do
  subject do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :url
      validates :url, http_url: true
    end.new
  end

  describe 'invalid url addresses' do
    ['nope', 'http', 'http:foo.com.', '.', ' '].each do |url|
      describe "when url address is #{url}" do
        it 'should add an error' do
          subject.url = url
          subject.validate
          expect(subject.errors[:url]).to include 'is not a valid HTTP URL'
        end
      end
    end
  end

  describe 'valid email addresses' do
    ['http://google.com', 'https://google.com'].each do |url|
      describe "when url address is #{url}" do
        it 'should not add an error' do
          subject.url = url
          subject.validate
          expect(subject.errors[:url]).not_to include 'is not a valid email address'
        end
      end
    end
  end
end
