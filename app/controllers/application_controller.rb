class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :skip_session_storage
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end

  # CORS プリフライト用のアクション
  def preflight
    head :no_content
  end
end
