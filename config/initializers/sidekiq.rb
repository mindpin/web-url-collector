Sidekiq.configure_server do |config|
  config.options[:queues] = %w{indexer image_uploader}
  config.redis = {url: R::REDIS_URL}
end

Sidekiq.configure_client do |config|
  config.redis = {url: R::REDIS_URL}
end
