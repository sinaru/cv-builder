# frozen_string_literal: true

module CvBuilder
  class CvData
    def initialize(hash)
      @hash = hash
    end

    def get_bindings
      binding
    end

    def dig(*path)
      # TODO: if experiences, return CvData::Experiences
      path_s = path.map(&:to_s)
      @hash.dig(*path_s)
    end
  end
end

