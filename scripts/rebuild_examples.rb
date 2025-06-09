require_relative "../lib/kamisaku"
require "fileutils"
require "optparse"

# Parse command line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-t", "--template TEMPLATE", "Use specific template instead of all templates") do |template|
    options[:template] = template
  end

  opts.on("-z", "--generate-html", "Generate HTML files") do
    options[:write_to_html_file] = true
  end

  opts.on("-k", "--category") do |category|
    options[:category] = category
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end.parse!

categories = options[:category] ? [options[:category]] : Kamisaku::PDF::CONTENT_VALIDATOR_MAP.keys

Kamisaku::PDF::CONTENT_VALIDATOR_MAP.select {|key, value| categories.include? key }.each do | category, klass |
  templates = klass::TEMPLATES

  # Use specified template or all templates
  templates = options[:template] ? templates.select {|t| t == options[:template] } : templates

  templates.each do |template|
    template_dir = File.expand_path("../examples/#{category}/#{template}", __dir__)
    FileUtils.mkdir_p(template_dir)

    pdf_file_path = File.expand_path("../examples/#{category}/#{template}/example.pdf", __dir__)

    example_yaml_fie = File.expand_path("../lib/schema/#{category}/example.yml", __dir__)
    yaml_str = File.read(example_yaml_fie)

    content_hash = Kamisaku::Helpers.yaml_str_to_content_hash(yaml_str)
    pdf = Kamisaku::PDF.new(content_hash:, category:, template:)
    puts "Building template #{template}"
    pdf.write_to(pdf_file_path)

    if options[:write_to_html_file]
      html_location = File.expand_path("../examples/#{category}/#{template}/example.html", __dir__)
      pdf.write_to_html_file(html_location)
    end
  end
end
