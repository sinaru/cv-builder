module Kamisaku
  class ContentValidator
    attr_reader :content_hash
    alias_method :data, :content_hash

    def initialize(content_hash:)
      @content_hash = content_hash
    end

    def validate!
      validate_version
      validate_profile
      validate_contact
      validate_skills
    end

    private

    def validate_version
      raise Error, "Invalid version" unless data[:version] && data[:version] == 1
    end

    def validate_profile
      raise Error, "Missing profile" unless data[:profile]
      raise Error, "Profile must be a hash" unless data[:profile].is_a?(Hash)

      allowed_fields = %i[name title about]
      profile_fields = data[:profile].keys

      unless profile_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "Profile contains invalid fields"
      end

      unless profile_fields.size == allowed_fields.size
        raise Error, "Profile must contain exactly the fields: #{allowed_fields.join(', ')}"
      end

      data[:profile].each do |field, value|
        unless value.is_a?(String)
          raise Error, "Profile field '#{field}' must be a string"
        end
      end
    end

    def validate_contact
      raise Error, "Missing contact" unless data[:contact]
      raise Error, "Contact must be a hash" unless data[:contact].is_a?(Hash)

      allowed_fields = %i[github mobile linkedin website email location]
      contact_fields = data[:contact].keys

      unless contact_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "Contact contains invalid fields"
      end

      allowed_fields.each do |field|
        raise Error, "Contact missing required field '#{field}'" unless contact_fields.include?(field)
      end

      data[:contact].each do |field, value|
        if field == :location
          validate_location(value)
        else
          raise Error, "Contact field '#{field}' must be a string" unless value.is_a?(String)
        end
      end
    end

    def validate_location(location)
      raise Error, "Location must be a hash" unless location.is_a?(Hash)

      allowed_fields = %i[country city]
      location_fields = location.keys

      unless location_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "Location contains invalid fields"
      end

      allowed_fields.each do |field|
        raise Error, "Location missing required field '#{field}'" unless location_fields.include?(field)
        raise Error, "Location field '#{field}' must be a string" unless location[field].is_a?(String)
      end
    end

    def validate_skills
      return unless data[:skills]

      raise Error, "Skills must be an array" unless data[:skills].is_a?(Array)

      data[:skills].each do |skill|
        raise Error, "Each skill must be a hash" unless skill.is_a?(Hash)

        allowed_fields = %i[area items]
        skill_fields = skill.keys

        unless skill_fields.all? { |field| allowed_fields.include?(field) }
          raise Error, "Skill contains invalid fields"
        end

        allowed_fields.each do |field|
          raise Error, "Skill missing required field '#{field}'" unless skill_fields.include?(field)
        end

        raise Error, "Skill field 'area' must be a string" unless skill[:area].is_a?(String)
        raise Error, "Skill field 'items' must be an array" unless skill[:items].is_a?(Array)

        skill[:items].each do |item|
          raise Error, "Each skill item must be a string" unless item.is_a?(String)
        end
      end
    end
  end
end