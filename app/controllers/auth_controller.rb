class AuthController < ApplicationController
  def new
  end

  def create
    store = Auth.new(params[:email], params[:password], self).login!
    set_cookie!(store)
    redirect_to("/")
  rescue
    redirect_to("/sign_in")
  end

  def destroy
    logout!
    redirect_to("/sign_in")
  end
end
