module Kamisaku
  class ChromeRunner
    def initialize(sandbox: false, headless: true, gpu: false)
      @base_args = ["--run-all-compositor-stages-before-draw"]
      @base_args << "--no-sandbox" unless sandbox
      @base_args << "--headless" if headless
      @base_args << "--disable-gpu" unless gpu
    end

    def html_to_pdf(html_path, pdf_path, pdf_header_footer: false)
      args = [*@base_args]
      args << "--no-pdf-header-footer" unless pdf_header_footer
      args << "--print-to-pdf=#{pdf_path}"
      args << html_path
      arg_str = args.join(" ")
      system("google-chrome #{arg_str}")
      Kamisaku::Error "PDF generation failed" unless File.exist?(pdf_path)
    end
  end
end
