# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def after_sign_in_path_for(*)
    books_path
  end

  def after_sign_out_path_for(*)
    user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password])

    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email profile postcode address])
  end
end
