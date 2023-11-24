# frozen_string_literal: true

require_relative "cv_builder/version"
require_relative "cv_builder/cv_data"
require_relative "cv_builder/cv_data_sections/skill"
require_relative "cv_builder/meta_file_parser"
require_relative "cv_builder/cv_generator"

module CvBuilder
  class Error < StandardError; end

  class Builder
    def run
      example_yaml = File.join(File.dirname(__FILE__), "/../examples/basic_cv.yml")
      parser = MetaFileParser.new(example_yaml)
      cv_data = parser.parse!

      output_location = File.join(File.dirname(__FILE__), "/../tmp/basic_cv.pdf")
      CvGenerator.new(cv_data).generate(output_location)
    end
  end
end
