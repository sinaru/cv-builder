# frozen_string_literal: true

require_relative "cv_builder/version"
require_relative "cv_builder/cv_data"
require_relative "cv_builder/cv_data_sections/skill"
require_relative "cv_builder/meta_file_parser"
require_relative "cv_builder/cv_generator"
require_relative "cv_builder/arg_parser"

module CvBuilder
  class Error < StandardError; end

  class Builder
    def run
      options = CvBuilder::ArgParser.parse!
      raise Error.new "CV info file does not exist" unless File.exist?(options[:cv_info])

      parser = MetaFileParser.new(options[:cv_info])
      cv_data = parser.parse!
      CvGenerator.new(cv_data).generate(options[:output_path])
    end
  end
end
