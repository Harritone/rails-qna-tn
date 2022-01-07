# frozen_string_literal: true

# Subscription represents table SUBSCRIPTIONS
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribable, polymorphic: true
  validates :user_id, uniqueness: { scope: %i[subscribable_type subscribable_id] }
end
