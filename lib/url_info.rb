require "uri"
class UrlInfo
  include Mongoid::Document
  include Mongoid::Timestamps

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
    res = JSON.parse(RestClient.post("http://s.4ye.me/parse", long_url: url_info.url))
    url_info.short_url = res["short_url"]
  end
end