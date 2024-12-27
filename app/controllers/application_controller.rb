class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :skip_session_storage
  before_action :configure_permitted_parameters, if: :devise_controller_with_devise?

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end

  def configure_permitted_parameters
    if respond_to?(:devise_parameter_sanitizer)
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
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
