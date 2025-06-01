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

        parser.on("-c", "--yaml-file INFO", "Require the INFO") do |yaml_file|
          options[:yaml_file] = yaml_file
        end

        parser.on("-o", "--pdf-file OUTPUT", "Require the OUTPUT") do |pdf_file|
          options[:pdf_file] = pdf_file
        end

        parser.on("-t", "--template TEMPLATE", "Provide the TEMPLATE name") do |template|
          options[:template] = template
        end
      end.parse!

      raise OptionParser::MissingArgument.new("-c") if options[:yaml_file].nil?
      raise OptionParser::MissingArgument.new("-o") if options[:pdf_file].nil?

      options
    end
  end
end
