module TagMethods
  def add_tags(secret, tags)
    raise 'url_info 还没有保存' if self.id.blank?
    param = {
      secret: secret, 
      scope: "web_page_collector",
      key: self.id,
      tags: tags
    }
    uri = URI.parse(R::WRITE_TAGS_URL)
    res = Net::HTTP.post_form(uri, param)
    raise '创建 tags 失败' if res.code != "200"
    info = JSON.parse(res.body)
    info["tags"]
  end
end