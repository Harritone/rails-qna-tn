# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }

  it 'sends daily digest for all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }

    DailyDigestService.new.send_digest
  end
end
