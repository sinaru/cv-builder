require "erb"

module Kamisaku
  class HtmlBuilder
    attr_reader :content_hash, :template
    alias_method :data, :content_hash

    include TemplateHelpers

    def initialize(content_hash, template)
      @content_hash = content_hash
      @template = template
    end

    def html
      rhtml = ::ERB.new(template_html)
      rhtml.result(binding)
    end

    private

    def template_html
      path = File.join(File.dirname(__FILE__), "/../templates/#{template}/template.html.erb")
      File.read(path)
    end
  end
end