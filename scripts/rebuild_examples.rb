
require_relative '../lib/kamisaku'
require 'fileutils'
require 'optparse'

# Parse command line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on('-t', '--template TEMPLATE', 'Use specific template instead of all templates') do |template|
    options[:template] = template
  end

  opts.on('-z', '--generate-html', 'Generate HTML files') do
    options[:generate_html] = true
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
end.parse!

example_yaml_fie = File.expand_path('../lib/schema/example.yml', __dir__)
yaml_str = File.read(example_yaml_fie)

# Use specified template or all templates
templates = options[:template] ? [options[:template]] : Kamisaku::TemplateHelpers::TEMPLATES

templates.each do |template|
  template_dir = File.expand_path("../examples/#{template}", __dir__)
  FileUtils.mkdir_p(template_dir)

  pdf_file_path = File.expand_path("../examples/#{template}/example.pdf", __dir__)

  content_hash = Kamisaku::Helpers.yaml_str_to_content_hash(yaml_str)
  pdf = Kamisaku::PDF.new(content_hash:, template:)
  puts "Building template #{template}"
  pdf.write_to(pdf_file_path)

  if options[:generate_html]
    html_location = File.expand_path("../examples/#{template}/example.html", __dir__)
    pdf.generate_html(html_location)
  end
end
