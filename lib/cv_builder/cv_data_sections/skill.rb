# frozen_string_literal: true

module CvDataSection
  class Skill
    def initialize(hash)
      @hash = hash
    end

    def get_bindings
      binding
    end

    def dig(*path)
      path_s = path.map(&:to_s)
      data = @hash.dig(*path_s)
      return [] if data.nil? && path.first == :items
      data
    end
  end
end

