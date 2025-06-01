require "psych"

module Kamisaku
  module Helpers
    def self.yaml_str_to_content_hash(yaml_str)
      Psych.safe_load(yaml_str, symbolize_names: true, aliases: false, freeze: true)
    rescue Psych::SyntaxError, Psych::DisallowedClass, Psych::AliasesNotEnabled => error
      raise Kamisaku::Error.new error.message
    end

    def self.remove_metadata_from_pdf_file(file_path)
      command = <<~CMD
        exiftool -all= #{file_path} -overwrite_original
      CMD
      system(command)
    end
  end
end
