require File.expand_path("../../config/env",__FILE__)

class WebUrlCollectorApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  set :sessions, true
  set :inline_templates, true

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

  get '/' do
    haml :index
  end
  
end