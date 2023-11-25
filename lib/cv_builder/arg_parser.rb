# frozen_string_literal: true

require "optparse"

module CvBuilder
  module ArgParser
    def self.parse!
      options = {}

      OptionParser.new do |parser|
        parser.on("-c", "--cv-info INFO", "Require the INFO") do |cv_info|
          p cv_info
          options[:cv_info] = cv_info
        end

        parser.on("-o", "--output-path OUTPUT", "Require the OUTPUT") do |output_path|
          options[:output_path] = output_path
        end
      end.parse!

      raise OptionParser::MissingArgument.new("Provide the location of CV yaml file") if options[:cv_info].nil?
      raise OptionParser::MissingArgument.new("Provide a valid path to generate the CV pdf file") if options[:output_path].nil?

      options
    end
  end
end
