module ApplicationHelper
  def current_user
    return if !user_id
    User.where(id: user_id).first
  end

  def user_id
    cookies.signed[R::COOKIE_KEY]
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

  protected

  def set_cookie!(user)
    cookies.permanent.signed[R::COOKIE_KEY] = user.id.to_s
  end
end
