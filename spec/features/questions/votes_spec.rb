require 'rails_helper'

feature 'User can vote for answer/question', %q{
  In order to have influence on question's rating
  As Authenticated user and being not author of the question
  I'd like to be able to vote for it
} do
  it_behaves_like 'voting' do
    given(:question) { create(:question) }

    given(:author) { question.user }
    given(:other_user) { create(:user) }
    given(:resource_voting_page) { question }
    given(:resource_rating_class) { '.question' }
  end
end
