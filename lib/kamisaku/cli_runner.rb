module Kamisaku
  class CLIRunner
    def self.run
      options = Kamisaku::ArgParser.parse!
      yaml_file = options[:yaml_file]
      raise Kamisaku::Error.new "YAML file does not exist" unless File.exist?(yaml_file)

      yaml_string = File.read(yaml_file)
      pdf = PDF.new(content_hash: Helpers.yaml_str_to_content_hash(yaml_string), category: options[:category], template: options[:template])
      pdf.write_to(options[:pdf_file])
      pdf.write_to_html_file(options[:html_output]) if options[:html_output]
    end
  end
end
