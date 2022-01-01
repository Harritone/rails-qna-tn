class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_user
  end

  def index
    users = User.where.not(id: current_user.id)
    render json: users
  end
end
