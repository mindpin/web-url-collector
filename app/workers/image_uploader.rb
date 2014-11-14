class ImageUploader
  include Sidekiq::Worker
  sidekiq_options :queue => :image_uploader, :retry => false

  def perform(info_id, image)
    logger.info "ImageUploader startedat: #{Time.now}"
    info = UrlInfo.find(info_id)

    logger.info "ImageUploader upload startedat: #{Time.now}"
    response  = Net::HTTP.post_form(URI("http://img.4ye.me/images"), :base64 => image)
    image_url = JSON.parse(response.body)["url"]
    logger.info "ImageUploader upload finished at: #{Time.now}"

    logger.info "ImageUploader update record started at: #{Time.now}"
    info.update_attributes(:image_url => image_url)
    logger.info "ImageUploader update record finished at: #{Time.now}"
    logger.info "ImageUploader finish at: #{Time.now}"
  end
end
