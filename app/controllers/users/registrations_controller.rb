class Users::RegistrationsController < Devise::RegistrationsController
  
  # DELETE /resource
  def destroy
    cookies_delete
    super
  end

  protected

  def after_sign_up_path_for(_resource)
    after_sign_up
    root_path
  end

end
