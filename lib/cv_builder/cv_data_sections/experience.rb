# frozen_string_literal: true

module CvDataSection
  class Experience < Base
    include ParseHelper::Date
    def dig(*path)
      data = super
      return [] if data.nil? && path.first == :technologies
      return [] if data.nil? && path.first == :achievements
      return to_month(data) if path[-2..] == [:from, :month]
      return to_month(data) if path[-2..] == [:to, :month]
      data
    end
  end
end
