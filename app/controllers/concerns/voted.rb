module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :revote]
    before_action :set_vote, only: [:vote_up, :vote_down, :revote]
    before_action :check_votable_author, only: [:vote_up, :vote_down, :revote]
  end

  def vote_up
    @vote.up
    render_json
  end

  def vote_down
    @vote.down
    render_json
  end

  def revote
    @vote.reset_vote
    render_json
  end

  private

  def render_json
    data = {
      id: @votable.id,
      resource: @votable.class.name.underscore,
      votes: @votable.votes_count
    }

    render json: data
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = Vote.find_by(user: current_user, votable: @votable)
    @vote ||= @votable.votes.build(user: current_user)
  end

  def check_votable_author
    head(:forbidden) if (!current_user || current_user.author_of?(@votable))
  end
end
