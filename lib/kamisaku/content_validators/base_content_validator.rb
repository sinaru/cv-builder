module Kamisaku
  class BaseContentValidator
    attr_reader :content_hash
    alias_method :data, :content_hash

    def initialize(content_hash:)
      @content_hash = content_hash
    end

    def validate!
      # Override by child class
    end
  end
end
