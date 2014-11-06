class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_filter :cors_settings

  protected

  def cors_settings
    headers['Access-Control-Allow-Origin']   = '*'
    headers['Access-Control-Allow-Methods']  = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
  end
end
