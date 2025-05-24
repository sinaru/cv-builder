# frozen_string_literal: true

require "erb"

module Kamisaku
  class CvGenerator
    attr_reader :pdf_location, :html_location, :cv_data, :template

    def initialize(cv_data, pdf_location:, html_location: nil, template: nil)
      @cv_data = cv_data
      @pdf_location = pdf_location
      @html_location = html_location
      @template = template || "sleek"
    end

    def generate
      generated_html_file do |file_path|
        FileUtils.cp(file_path, html_location) if html_location
        html_file_to_pdf_file(file_path, pdf_location)
        soft_remove_metadata_from_pdf_file(pdf_location)
      end
    end

    private

    def html_file_to_pdf_file(html_file_path, pdf_file_path)
      # Convert the HTML file to a PDF using Google Chrome in headless mode
      pdf_conversion_command = <<~CMD
        google-chrome --headless --disable-gpu --run-all-compositor-stages-before-draw \
                      --print-to-pdf=#{pdf_file_path} --no-pdf-header-footer \
                      #{html_file_path}
      CMD

      system(pdf_conversion_command)
      raise "PDF generation failed" unless File.exist?(pdf_file_path)
    end

    def soft_remove_metadata_from_pdf_file(file_path)
      command = <<~CMD
        exiftool -all= #{file_path} -overwrite_original
      CMD
      system(command)
    end

    def generated_html_file
      temp_html_file = Tempfile.new(%w[kamisaku .html])
      temp_html_file.write(cv_html)
      temp_html_file.close
      begin
        yield temp_html_file.path
      ensure
        temp_html_file.unlink
      end
    end

    def cv_html
      rhtml = ERB.new(template_html)
      rhtml.result(@cv_data.get_bindings)
    end

    def template_html
      path = File.join(File.dirname(__FILE__), "/../templates/#{template}/template.html.erb")
      File.read(path)
    end
  end
end
