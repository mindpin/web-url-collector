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

  def search_q
    @infos = UrlInfo.quick_search(params[:q])
    render "url_infos/search_q", layout: false
  end

  def search
  end
end
