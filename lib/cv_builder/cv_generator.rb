# frozen_string_literal: true

require "erb"
require "pdfkit"

module CvBuilder
  class CvGenerator
    def initialize(cv_data)
      @cv_data = cv_data
      @template = "basic"
    end

    ## Generate CV PDF file using PDFKit. In future if an alternative approach is needed (e.g. using Prawn gem),
    # consider refactoring code to follow strategy pattern.
    def generate(output_location)
      pdf = PDFKit.new(cv_html, page_size: "A4")
      pdf.stylesheets = template_stylesheets
      pdf.to_file(output_location)
    end

    private

    def cv_html
      rhtml = ERB.new(template_html)
      rhtml.result(@cv_data.get_bindings)
    end

    def template_html
      path = File.join(File.dirname(__FILE__), "/../templates/#{@template}/index.html.erb")
      File.read(path)
    end

    def template_stylesheets
      [File.join(File.dirname(__FILE__), "/../templates/#{@template}/styles/index.css")]
    end
  end
end
