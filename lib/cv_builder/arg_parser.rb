# frozen_string_literal: true

require "optparse"

module CvBuilder
  module ArgParser
    def self.parse!
      options = {}

      OptionParser.new do |parser|
        parser.on("-c", "--cv-info INFO") do |cv_info|
          p cv_info
          options[:cv_info] = cv_info
        end

        parser.on("-o", "--output-path OUTPUT") do |output_path|
          options[:output_path] = output_path
        end
      end.parse!

      options
    end
  end
end
