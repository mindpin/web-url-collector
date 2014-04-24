class UrlInfosController < ApplicationController
  def show
    @url_info = UrlInfo.find(params[:id])
  end

  def destroy
    @url_info = UrlInfo.find(params[:id])
    @url_info.destroy
    render json: {status: 'ok'}
  end

  def create
    user_store = find_by_secret(params[:secret])
    if !params[:update]
      url_info = user_store.url_infos.create!(
        url:       params[:url],
        title:     params[:title],
        desc:      params[:desc],
        image_url: params[:image_url]
      )
    else
      url_info = user_store.url_infos.where(url: params[:url]).first
      url_info.update_attributes(
        title:     params[:title],
        desc:      params[:desc],
        image_url: params[:image_url]
      )
    end
    tags = url_info.add_tags(params[:tags])
    res = {
      url: url_info.url,
      short_url: url_info.short_url,
      title: url_info.title,
      desc: url_info.desc,
      image_url: url_info.image_url,
      tags: tags, 
      user_id: user_store.uid,
      user_name: user_store.name,
      site_url: "http://collect.4ye.me/url_infos/#{url_info.id}"
    }
    render json: res
  rescue Exception => ex
    render json: {status: 'error', info: ex.message}, status: 400
  end

  def check
    user_store = find_by_secret(params[:secret])
    url_info = user_store.url_infos.where(url: params[:url]).first
    if url_info.blank?
      res = {
        collected: false,
        data: {
          url: params[:url],
          short_url:  UrlInfo.get_short_url(params[:url])
        }
      }
    else
      res = {
        collected: true,
        data: {
          url: url_info.url,
          short_url: url_info.short_url,
          title: url_info.title,
          desc: url_info.desc,
          image_url: url_info.image_url,
          tags: url_info.tags_array, 
          user_id: user_store.uid,
          user_name: user_store.name,
          site_url: "http://collect.4ye.me/url_infos/#{url_info.id}"
        }
      }
    end
    render json: res
  rescue Exception => ex
    render json: {status: 'error', info: ex.message}, status: 400
  end

  def plugin
  end
end
