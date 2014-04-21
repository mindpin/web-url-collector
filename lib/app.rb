require File.expand_path("../../config/env",__FILE__)

class WebUrlCollectorApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  set :views, ["templates"]
  set :root, File.expand_path("../../", __FILE__)
  register Sinatra::AssetPack

  assets {
    serve '/js', :from => 'assets/javascripts'
    serve '/css', :from => 'assets/stylesheets'

    js :application, "/js/application.js", [
      '/js/jquery-1.11.0.min.js',
      '/js/**/*.js'
    ]

    css :application, "/css/application.css", [
      '/css/**/*.css'
    ]

    css_compression :yui
    js_compression  :uglify
  }

  set :cookie_options, domain: nil
  helpers Sinatra::Cookies

  helpers do
    def current_store
      Auth.current_store(self)
    end

    def login?
      !current_store.blank?
    end
  end

  before do
    headers("Access-Control-Allow-Origin" => "*")
    if !request.path_info.match(/^\/url_infos.*$/).blank?
      redirect "/" if !login?
    end
  end

  get "/" do
    redirect to("/login") if !current_store
    haml :index
  end

  get "/login" do
    haml :login
  end

  post "/login" do
    begin
      Auth.new(params[:login], params[:password], self).login!
      return redirect to("/")
    rescue
      redirect to("/login")
    end
  end

  get "/logout" do
    Auth.logout(self)
    redirect to("/")
  end

  post "/collect_url" do
    begin
      user_store = Auth.find_by_secret(params[:secret])
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
      json res
    rescue Exception => ex
      status 400
      json status: 'error', info: ex.message
    end
  end

  post "/check_url" do
    begin
      user_store = Auth.find_by_secret(params[:secret])
      url_info = user_store.url_infos.where(url: params[:url]).first
      if url_info.blank?
        res = {
          collected: false,
          data: {
            url: params[:url],
            short_url:  UrlInfo.get_short_url(params[:url])
          }
        }
        json res
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
        json res
      end
    rescue Exception => ex
      status 400
      json status: 'error', info: ex.message
    end
  end

  get "/url_infos/:id" do
    @url_info = UrlInfo.find(params[:id])
    haml :url_info_show
  end

  delete "/url_infos/:id/destroy" do
    @url_info = UrlInfo.find(params[:id])
    @url_info.destroy
    json status: 'ok'
  end
  
end