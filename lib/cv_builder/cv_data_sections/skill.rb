# frozen_string_literal: true

module CvDataSection
  class Skill < Base
    def dig(*path)
      data = super
      return [] if data.nil? && path.first == :items
      data
    end
  end
end
