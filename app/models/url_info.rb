class UrlInfo
  include Mongoid::Document
  include Mongoid::Timestamps
  include TagMethods
  include Searchable

  belongs_to :user

  searchable :title, :desc, :tags_array

  field :url, type: String
  field :title, type: String
  field :desc, type: String
  field :image_url, type: String
  field :short_url, type: String
  field :favicon_url, type: String

  validates :url, presence: true
  validates :url, :uniqueness => {:scope => :user_id}
  validates :url, format: {
    with: URI::regexp(%w(http https))
  }
  validates :title, presence: true
  validates :user_id, presence: true
  validates :short_url, presence: true

  default_scope ->{order_by("updated_at DESC")}

  before_validation do |url_info|
    url_info.short_url = UrlInfo.get_short_url(url_info.url)
  end

  after_create do
    ImageUploader.perform_async(self.id.to_s, self.image) if self.image
  end

  def self.get_short_url(url)
    uri = URI.parse(R::SHORT_URL_URL)
    res = Net::HTTP.post_form(uri, long_url: url)
    if res.code == "200"
      info = JSON.parse(res.body)
      return info["short_url"]
    end
    return ""
  end

  def image
    @image
  end

  def image=(img)
    @image = img
  end

  def site
    url = self.url

    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def desc
    attributes["desc"] || ""
  end

  def html_desc
    self.desc.gsub "\n", "<br/>"
  end

  def as_indexed_json(options={})
    as_json(options).merge(tags_array: tags_array,
                           html_desc:  html_desc,
                           site:       site)
  end
end
