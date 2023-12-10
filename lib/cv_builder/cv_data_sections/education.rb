# frozen_string_literal: true

module CvDataSection
  class Education < Base
    include ParseHelper::Date

    def dig(*path)
      data = super
      return [] if data.nil? && path.first == :achievements
      return to_month(data) if path[-2..] == [:from, :month]
      data
    end
  end
end