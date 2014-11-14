class IndexController < ApplicationController
  def index
    return redirect_to "/sign_in" if not signed_in?
    @url_infos = current_user.url_infos.page(params[:page])
  end

  def tag
    return redirect_to "/sign_in" if not signed_in?
    @url_infos = UrlInfo.find_by_tags(current_user, [params[:tag]]).sort do |a, b|
      b.updated_at <=> a.updated_at
    end
    render :index
  end
end
