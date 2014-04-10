require "uri"
class UrlInfo
  include Mongoid::Document
  include Mongoid::Timestamps
  include TagMethods

  belongs_to :user_store
  field :url, type: String
  field :title, type: String
  field :desc, type: String
  field :image_url, type: String
  field :short_url, type: String

  validates :url, presence: true
  validates :url, :uniqueness => {:scope => :user_store_id}
  validates :url, format: {
    with: URI::regexp(%w(http https))
  }
  validates :title, presence: true
  validates :user_store_id, presence: true
  validates :short_url, presence: true

  before_validation do |url_info|
    uri = URI.parse(R::SHORT_URL_URL)
    res = Net::HTTP.post_form(uri, long_url: url_info.url)
    if res.code == "200"
      info = JSON.parse(res.body)
      url_info.short_url = info["short_url"]
    end
  end
end