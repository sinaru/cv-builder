# frozen_string_literal: true

require "optparse"

module Kamisaku
  module ArgParser
    def self.parse!
      options = {}

      OptionParser.new do |parser|
        parser.on("--html-debug-path HTML_OUTPUT") do |html_output|
          options[:html_output] = html_output
        end

        parser.on("-c", "--cv-info INFO", "Require the INFO") do |cv_info|
          options[:cv_info] = cv_info
        end

        parser.on("-o", "--output-path OUTPUT", "Require the OUTPUT") do |output_path|
          options[:output_path] = output_path
        end

        parser.on("-t", "--template-path TEMPLATE", "Provide the TEMPLATE name") do |template|
          options[:template] = template
        end
      end.parse!

      raise OptionParser::MissingArgument.new("Provide the location of CV yaml file") if options[:cv_info].nil?
      raise OptionParser::MissingArgument.new("Provide a valid path to generate the CV pdf file") if options[:output_path].nil?

      options
    end
  end
end
