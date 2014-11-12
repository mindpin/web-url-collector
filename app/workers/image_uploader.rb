class ImageUploader
  include Sidekiq::Worker
  sidekiq_options :queue => :image_uploader, :retry => false

  def perform(info_id, image)
    info = UrlInfo.find(info_id)

    response  = Net::HTTP.post_form(URI("http://img.4ye.me/images"), :base64 => image)
    image_url = JSON.parse(response.body)["url"]

    info.update_attributes(:image_url => image_url)
  end
end
