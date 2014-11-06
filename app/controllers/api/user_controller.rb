class Api::UserController < ApplicationController
  def info
    if current_user.blank?
      return render :text => 401, :status => 401
    end
    
    render :json => {
      name: current_user.name,
      avatar: "http://tp1.sinaimg.cn/1676582524/180/5696180355/1"
    }
  end
end