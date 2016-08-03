class Users::SessionsController < Devise::SessionsController

  def destroy
    cookies.delete :user_products_count
    session[:user_products_count] = ''
    super
  end
end
