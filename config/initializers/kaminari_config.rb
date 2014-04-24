Kaminari.configure do |config|
  config.default_per_page = 25
  config.max_per_page = nil
  config.window = 1
  config.outer_window = 1
  config.left = 0
  config.right = 0
  config.page_method_name = :page
  config.param_name = :page
end

# 1) Run rails g kaminari:views default to generate copy of kaminari views inside your app
# 2) Override Kaminari::Helpers::Tag#to_s as shown here:
module Kaminari
  module Helpers
    class Tag
      def to_s(locals = {}) #:nodoc:
        @template.render :partial => "../views/kaminari/#{@theme}#{self.class.name.demodulize.underscore}", :locals => @options.merge(locals)
      end
    end
  end
end