class HomeController < ApplicationController
  def show
    return redirect_to "/sign_in" if !signed_in?

    @url_infos = current_user.url_infos.page(params[:page])
  end
end
