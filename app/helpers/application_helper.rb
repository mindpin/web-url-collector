module ApplicationHelper
  def current_user
    return if !user_id
    User.where(id: user_id).first
  end

  def user_id
     auth_info["user_id"] || cookies.signed[R::COOKIE_KEY]
  end

  def signed_in?
    !current_user.blank?
  end

  def logout!
    cookies.delete R::COOKIE_KEY
  end

  def get_plugin_script
    token = current_user.token
    site = request.url.sub request.path_info, ''
    "javascript:void(function(d){window.USER_TOKEN='#{token}';window.M4YE_SITE='#{site}/';var l=function(u){var e=d.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src',u);d.body.appendChild(e)};l(window.M4YE_SITE+'web-url-collector.js?r='+Math.random())}(document));"
  end

  def issue_token(user)
    claim = {
      :user_id => user.id.to_s,
      :nbf     => Time.now,
      :exp     => 1.month.from_now
    }

    JWT.encode(claim, secret_key_base)
  end

  def auth_header
    request.env["HTTP_ATHORIZATION"]
  end

  def token
    auth_header.to_s.split(" ").last
  end

  def auth_info
    token ? JWT.decode(token, secret_key_base)[0] : {}
  end

  def secret_key_base
    Rails.application.secrets[:secret_key_base]
  end

  protected

  def set_cookie!(user)
    cookies.permanent.signed[R::COOKIE_KEY] = user.id.to_s
  end
end
