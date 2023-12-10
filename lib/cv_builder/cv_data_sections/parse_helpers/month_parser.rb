# frozen_string_literal: true

require "date"

module CvDataSection
  module ParseHelper
    module Date
      private

      def to_month(month_int)
        return "" if month_int.nil?

        ::Date::MONTHNAMES[month_int]
      end
    end
  end
end
