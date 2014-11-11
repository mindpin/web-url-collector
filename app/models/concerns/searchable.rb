module Searchable
  extend ActiveSupport::Concern 

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    __elasticsearch__.client = Elasticsearch::Client.new log: true

    Searchable.enabled_models.add(self)
  end

  def self.enabled_models
    @_enabled_models ||= Set.new
  end

  def as_indexed_json(options={})
    as_json
  end

  module ClassMethods
    def searchable(*fields)
      search_fields.merge fields

      settings :index => {:number_of_shards => 1}, :analysis => analysis do
        mappings :dynamic => "false" do
          fields.each do |field|
            indexes field, :analyzer => :chargram
          end
        end
      end
    end

    def analysis
      {
        :analyzer => {
          :chargram => {
            :type => :custom,
            :tokenizer => :chargram,
            :filter => [:lowercase]
          }
        },

        :tokenizer => {
          :chargram => {
            :type => :edgeNGram,
            :min_gram => 1,
            :max_gram => 128,
            :token_chars => [:letter, :digit],
            :side => :front
          }
        }
      }
    end

    def quick_search(q, from: 0, size: 20)
      self.search(search_params(q, from, size))
    end

    def search_params(q, from = 0, size = 0)
      highlight = search_fields.reduce({}) do |hash, field|
        hash[field] = {}
        hash
      end

      {
        :from => from,
        :size => size,
        :query => {
          :multi_match => {
            :fields   => search_fields.to_a,
            :type     => :phrase,
            :query    => q,
            :analyzer => :chargram
          }
        },

        :highlight => {
          :pre_tags => ["<em class='highlight'>"],
          :post_tags => ["</em>"],
          :fields => highlight
        }
      }
    end

    def search_fields
      @_search_fields ||= Set.new
    end
  end
end
