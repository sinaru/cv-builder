require "date"

module Kamisaku
  module TemplateHelpers
    def month_name(month_int)
      return "" if month_int.nil?

      ::Date::MONTHNAMES[month_int]
    end
  end
end
