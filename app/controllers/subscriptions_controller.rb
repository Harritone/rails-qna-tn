# frozen_string_literal: true

# SubscriptionsController is responsible for create and destroy subscriptuns to Question
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscribable, only: :create

  load_and_authorize_resource

  def create
    @subscribable.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
  end

  private

  def set_subscribable
    subscribable_type = params[:subscribable_type]
    subscribable_id = params[:subscribable_id]
    @subscribable = ActiveSupport::Dependencies
                    .constantize(subscribable_type.capitalize)
                    .find(subscribable_id)
  end
end
