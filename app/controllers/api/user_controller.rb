class Api::UserController < ApplicationController
  def info
    if current_user.blank?
      return render :text => 401, :status => 401
    end
    
    render :json => {
      name: current_user.name,
      avatar: current_user.avatar,
      collection_count: current_user.url_infos.count
    }
  end
end