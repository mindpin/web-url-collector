class UrlInfosController < ApplicationController
  def show
    @url_info = UrlInfo.find(params[:id])
  end

  def destroy
    @url_info = UrlInfo.find(params[:id])
    @url_info.destroy
    render json: {status: 'ok'}
  end

  def plugin
  end
end
