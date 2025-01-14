class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :skip_session_storage
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end

  def configure_permitted_parameters
    Rails.logger.debug "DeviseTokenAuth: 許可されるパラメータの設定を適用"
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # Deviseのコントローラーでのみフィルターを実行する
  def devise_controller_with_devise?
    self.class <= Devise::SessionsController || self.class <= Devise::RegistrationsController
  end

  # CORS プリフライト用のアクション
  def preflight
    head :no_content
  end
end
