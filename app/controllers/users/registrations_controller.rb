# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_update_path_for(*)
    user_path(current_user)
  end
end
