class Api::AuthController < ApplicationController
  def check
    if !signed_in?
      return render nothing: true, status: 401
    end

    render json: {
      name: '我是名字',
      avatar: "http://tp1.sinaimg.cn/1676582524/180/5696180355/1"
    }
  end

end