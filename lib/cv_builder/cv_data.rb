# frozen_string_literal: true

module CvBuilder
  class CvData
    def initialize(hash)
      @hash = hash
    end

    def get_bindings
      binding
    end

    def has?(*path)
      klasses = [CvDataSection::Skill, CvDataSection::Experience]
      if klasses.any? { |klass| path.first.instance_of? klass }
        return path.first.has?(*path[1..])
      end

      path_s = path.map(&:to_s)
      !@hash.dig(*path_s).nil?
    end

    def dig(*path)
      klasses = [CvDataSection::Skill, CvDataSection::Experience]
      if klasses.any? { |klass| path.first.instance_of? klass }
        return path.first.dig(*path[1..])
      end

      # TODO: if experiences, return CvData::Experiences
      path_s = path.map(&:to_s)
      case path_s.first
      when "skills"
        @hash[path_s.first].each do |skill_hash|
          yield CvDataSection::Skill.new(skill_hash)
        end
      when "experiences"
        @hash[path_s.first].each do |skill_hash|
          yield CvDataSection::Experience.new(skill_hash)
        end
      else
        @hash.dig(*path_s)
      end
    end
  end
end
