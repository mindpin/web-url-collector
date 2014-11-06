class Api::UrlInfosController < ApplicationController
  before_filter :check_current_user
  def check_current_user
    if current_user.blank?
      return render :text => 401, :status => 401
    end
  end

  def create
    if !params[:update]
      url_info = current_user.url_infos.create!(
        url:       params[:url],
        title:     params[:title],
        desc:      params[:desc],
        image_url: params[:image_url]
      )
    else
      url_info = current_user.url_infos.where(url: params[:url]).first
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
      user_id: current_user.uid,
      user_name: current_user.name,
      site_url: "http://collect.4ye.me/url_infos/#{url_info.id}"
    }
    render json: res
  rescue Exception => ex
    render json: {status: 'error', info: ex.message}, status: 400
  end

  def check
    url_info = current_user.url_infos.where(url: params[:url]).first
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
          user_id: current_user.uid,
          user_name: current_user.name,
          site_url: "http://collect.4ye.me/url_infos/#{url_info.id}"
        }
      }
    end
    render json: res
  rescue Exception => ex
    render json: {status: 'error', info: ex.message}, status: 400
  end

end
