class HomeController < ApplicationController
  def show
    return redirect_to "/sign_in" if !signed_in?

    @url_infos = current_store.url_infos.page(params[:page])
  end
end
