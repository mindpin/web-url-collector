# coding: utf-8
module TagMethods
  def add_tags(tags)
    return [] if tags.blank?
    raise 'url_info 还没有保存' if self.id.blank?
    param = {
      token: user.token, 
      scope: R::TAG_SCOPE,
      key: self.id,
      tags: tags
    }
    uri = URI.parse(R::WRITE_TAGS_URL)
    res = Net::HTTP.post_form(uri, param)
    raise '创建 tags 失败' if res.code != "200"
    info = JSON.parse(res.body)
    info["tags"]
  end

  def tags_array
    raise 'url_info 还没有保存' if self.id.blank?
    uri = URI.parse(_read_tags_url(user.token))
    res = Net::HTTP.get_response(uri)
    raise '获取 tags 失败' if res.code != "200"
    info = JSON.parse(res.body)
    info["tags"]
  end

  private

  def _read_tags_url(token)
    "#{R::READ_TAGS_URL}?token=#{token}&scope=#{R::TAG_SCOPE}&key=#{self.id}"
  end
end

