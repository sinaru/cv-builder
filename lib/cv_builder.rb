# frozen_string_literal: true

require_relative "cv_builder/version"
require_relative "cv_builder/cv_data"
require_relative "cv_builder/yaml_file_parser"
require_relative "cv_builder/cv_generator"

module CvBuilder
  class Error < StandardError; end
  class Builder
    def run
      example_yaml = File.join(File.dirname(__FILE__), "/../examples/basic_cv.yml")
      parser = YamlFileParser.new(example_yaml)
      parser.validate!

      output_location = File.join(File.dirname(__FILE__), "/../tmp/basic_cv.pdf")
      data = parser.parse!
      CvGenerator.new(data, output_location).generate
    end
  end
end
