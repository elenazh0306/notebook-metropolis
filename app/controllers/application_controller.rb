class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :detect_mobile_app
  helper_method :mobile_app?

  # Pundit: allow-list approach
  # after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You can't do that here!"
    redirect_to(root_path)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :map_size])

    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def detect_mobile_app
    @is_mobile_app = request.user_agent.to_s.include?("TurboNative") || request.headers["X-Mobile-App"].present?
  end
  private

  def mobile_app?
    request.user_agent&.include?("NotebookMetropolisNativeApp")
  end
end
