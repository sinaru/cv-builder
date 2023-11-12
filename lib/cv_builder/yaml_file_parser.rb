# frozen_string_literal: true
require 'yaml'

module CvBuilder
  class YamlFileParser
    attr_reader :location

    def initialize(location)
      @location = location

    end

    def validate!
      # TODO: Check if file contains correct fields
    end

    def parse!
      CvData.new(yaml)
    end

    def yaml
      @yaml ||= YAML.load(File.read(location))
    end
  end
end