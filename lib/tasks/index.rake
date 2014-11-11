namespace :index do
  desc "导入相关模型的ElasticSearch索引"
  task :import => [:environment] do
    [UrlInfo].each do |model|
      puts "====: 开始导入 #{model.to_s} 的索引"
      model.__elasticsearch__.create_index! force: true
      model.import :force => true
      model.each(&:save)
      puts "====: 导入完毕."
    end
  end
end
