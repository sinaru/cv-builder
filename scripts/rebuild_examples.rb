require_relative '../lib/kamisaku'
require 'fileutils'

example_yaml_fie = File.expand_path('../lib/schema/example.yml', __dir__)
yaml_str = yaml_str = File.read(example_yaml_fie)

Kamisaku::TemplateHelpers::TEMPLATES.each do |template|
  template_dir = File.expand_path("../examples/#{template}", __dir__)
  FileUtils.mkdir_p(template_dir)

  pdf_file_path = File.expand_path("../examples/#{template}/example.pdf", __dir__)

  content_hash = Kamisaku::Helpers.yaml_str_to_content_hash(yaml_str)
  pdf = Kamisaku::PDF.new(content_hash:, template:)
  pdf.write_to(pdf_file_path)
end