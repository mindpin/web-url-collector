module BSON
  class ObjectId
    def to_json(options={})
      to_s
    end

    def as_json(options={})
      to_s
    end
  end
end
