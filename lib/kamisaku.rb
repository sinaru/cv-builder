# frozen_string_literal: true

require_relative "kamisaku/version"
require_relative "kamisaku/cv_data_sections/parse_helpers/month_parser"
require_relative "kamisaku/cv_data_sections/base"
require_relative "kamisaku/cv_data_sections/skill"
require_relative "kamisaku/cv_data_sections/interest"
require_relative "kamisaku/cv_data_sections/experience"
require_relative "kamisaku/cv_data_sections/education"
require_relative "kamisaku/cv_data"
require_relative "kamisaku/meta_file_parser"
require_relative "kamisaku/cv_generator"
require_relative "kamisaku/arg_parser"
require_relative "kamisaku/pdf"

module Kamisaku
  class Error < StandardError; end

  class Builder
    def run
      options = Kamisaku::ArgParser.parse!
      raise Error.new "CV info file does not exist" unless File.exist?(options[:cv_info])

      parser = MetaFileParser.new(options[:cv_info])
      cv_data = parser.parse!
      CvGenerator.new(cv_data, pdf_location: options[:output_path], html_location: options[:html_output], template: options[:template]).generate
    end
  end
end
