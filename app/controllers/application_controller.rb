class ApplicationController < ActionController::Base
  respond_to :html, :json, :js

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { response: exception.message }, status: 403 }
      format.js   { render json: { response: exception.message }, status: 403 }
    end
  end
end
