# frozen_string_literal: true
require 'date'

module CvDataSection
  class Experience
    def initialize(hash)
      @hash = hash
    end

    def get_bindings
      binding
    end

    def dig(*path)
      path_s = path.map(&:to_s)
      data = @hash.dig(*path_s)
      return [] if data.nil? && path.first == :technologies
      return to_month(data) if path[-2..] == [:from, :month]
      data
    end

    def has?(*path)
      path_s = path.map(&:to_s)
      data = @hash.dig(*path_s)
      !data.nil?
    end

    private

    def to_month(month_int)
      Date::MONTHNAMES[month_int]
    end
  end
end
