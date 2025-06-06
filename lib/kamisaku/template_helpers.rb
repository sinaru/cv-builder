require "date"

module Kamisaku
  module TemplateHelpers
    TEMPLATES = %w[paper sleek zenith meridian].freeze

    def month_name(month_int)
      return "" if month_int.nil?

      ::Date::MONTHNAMES[month_int]
    end
  end
end
