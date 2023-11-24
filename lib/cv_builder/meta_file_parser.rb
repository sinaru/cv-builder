# frozen_string_literal: true
require "yaml"

module CvBuilder
  class MetaFileParser
    attr_reader :location

    def initialize(location)
      @location = location

    end

    def validate!
      # TODO: Check if file contains correct fields
    end

    def parse!
      validate!
      CvData.new(yaml)
    end

    def yaml
      @yaml ||= YAML.load_file(location)
    end
  end
end