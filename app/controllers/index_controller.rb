class IndexController < ApplicationController
  def index
    return redirect_to "/sign_in" if not signed_in?
    @url_infos = current_user.url_infos.page(params[:page])
  end

  def tag
    render :text => params[:tag]
  end
end
