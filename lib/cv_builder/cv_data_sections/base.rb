# frozen_string_literal: true

module CvDataSection
  class Base
    def initialize(hash)
      @hash = hash
    end

    def get_bindings
      binding
    end

    def has?(*path)
      path_s = path.map(&:to_s)
      data = @hash.dig(*path_s)
      !data.nil?
    end

    def dig(*path)
      path_s = path.map(&:to_s)
      @hash.dig(*path_s)
    end
  end
end
