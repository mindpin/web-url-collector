class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_filter :cors_settings

  rescue_from(JWT::DecodeError) {render nothing: true, status: 401}

  protected

  def cors_settings
    headers['Access-Control-Allow-Origin']   = '*'
    headers['Access-Control-Allow-Methods']  = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
  end
end
