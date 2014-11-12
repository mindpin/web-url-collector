class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: "indexer", retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new logger: Logger

  def perform(operation, record_id, class_name)
    logger.debug [operation, "ID: #{record_id}"]

    klass  = class_name.constantize
    client = klass.__elasticsearch__.client
    type   = class_name.underscore
    index  = type.pluralize

    case operation.to_s
      when /index/
        record = klass.find(record_id)
        record.__elasticsearch__.index_document
      when /update/
        record = klass.find(record_id)
        record.__elasticsearch__.update_document
      when /delete/
        client.delete index: index, type: type, id: record_id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
