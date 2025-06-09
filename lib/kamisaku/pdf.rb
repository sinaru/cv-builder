require "tempfile"

module Kamisaku
  class PDF
    attr_reader :content_hash, :category, :template

    CONTENT_VALIDATOR_MAP = {
      resume: ResumeContentValidator,
      birthday_invitation: BirthdayInvitationContentValidator
    }

    def initialize(content_hash:, category:, template:)
      @content_hash = content_hash
      @category = category
      @template = template
      raise Error, "Invalid template name '#{template}'" unless template.is_a?(String)
      validator_klass = CONTENT_VALIDATOR_MAP[category.to_sym]
      raise Error, "Invalid template name '#{category}'" unless validator_klass
      validator_klass.new(content_hash:).validate!
      raise Error, "Invalid template name '#{template}'" unless validator_klass::TEMPLATES.include?(template)
    end

    def write_to(pdf_location)
      html_file do |file_path|
        html_file_to_pdf_file(file_path, pdf_location)
        Helpers.remove_metadata_from_pdf_file(pdf_location)
      end
    end

    def write_to_html_file(html_location)
      html_file { |file_path| FileUtils.cp(file_path, html_location) }
    end

    private

    def html_file_to_pdf_file(html_file_path, pdf_file_path)
      runner = ChromeRunner.new
      runner.html_to_pdf(html_file_path, pdf_file_path)
    end

    def html_file
      temp_html_file = Tempfile.new(%w[kamisaku .html])
      temp_html_file.write(html)
      temp_html_file.close
      begin
        yield temp_html_file.path
      ensure
        temp_html_file.unlink
      end
    end

    def html
      return @html if defined? @html

      builder = HtmlBuilder.new(content_hash, category, template)
      @html = builder.html
    end
  end
end
