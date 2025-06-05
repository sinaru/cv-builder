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
      validate_experiences
    end

    private

    def validate_version
      raise Error, "Invalid version" unless data[:version] && data[:version] == 1
    end

    def validate_profile
      raise Error, "Missing profile" unless data[:profile]
      raise Error, "Profile must be a hash" unless data[:profile].is_a?(Hash)

      allowed_fields = %i[name title about photo_url]
      required_fields = %i[name title about]
      profile_fields = data[:profile].keys

      unless profile_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "Profile contains invalid fields"
      end

      unless required_fields.all? { |field| profile_fields.include?(field) }
        raise Error, "Profile must contain exactly the fields: #{allowed_fields.join(", ")}"
      end

      data[:profile].each do |field, value|
        unless value.is_a?(String)
          raise Error, "Profile field '#{field}' must be a string"
        end
      end

      if data[:profile][:photo_url]
        validate_photo_url(data[:profile][:photo_url])
      end
    end

    def validate_photo_url(photo_url)
      raise Error, "Profile field '#{field}' must be a string" unless photo_url.is_a?(String)

      valid_url_regex = /\Ahttps?:\/\/.+\.(jpg|jpeg)\z/i
      unless valid_url_regex.match?(photo_url)
        raise Error, "Invalid photo_url. It must be an HTTP/HTTPS URL ending with .jpg or .jpeg"
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

      data[:contact].each do |field, value|
        if field == :location
          validate_location(value, "Contact section")
        else
          raise Error, "Contact field '#{field}' must be a string" unless value.is_a?(String)
        end
      end
    end

    def validate_location(location, section)
      raise Error, "#{section}: Location must be a hash" unless location.is_a?(Hash)

      allowed_fields = %i[country city]
      location_fields = location.keys

      unless location_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "#{section}: Location contains invalid fields"
      end

      allowed_fields.each do |field|
        raise Error, "#{section}: Location missing required field '#{field}'" unless location_fields.include?(field)
        raise Error, "#{section}: Location field '#{field}' must be a string" unless location[field].is_a?(String)
      end
    end

    def validate_skills
      return unless data[:skills]

      raise Error, "Skills must be an array" unless data[:skills].is_a?(Array)

      data[:skills].each do |skill|
        raise Error, "Each skill must be a hash" unless skill.is_a?(Hash)

        allowed_fields = %i[name items]
        skill_fields = skill.keys

        unless skill_fields.all? { |field| allowed_fields.include?(field) }
          raise Error, "Skills section: Skill contains invalid fields"
        end

        allowed_fields.each do |field|
          raise Error, "Skills section: Skill missing required field '#{field}'" unless skill_fields.include?(field)
        end

        raise Error, "Skills section: Skill field 'name' must be a string" unless skill[:name].is_a?(String)
        raise Error, "Skills section: Skill field 'items' must be an array" unless skill[:items].is_a?(Array)

        skill[:items].each do |item|
          raise Error, "Skills section: Each skill item must be a string" unless item.is_a?(String)
        end
      end
    end

    def validate_experiences
      return unless data[:experiences]

      raise Error, "Experiences must be an array" unless data[:experiences].is_a?(Array)

      data[:experiences].each do |experience|
        raise Error, "Each experience must be a hash" unless experience.is_a?(Hash)

        allowed_fields = %i[title organisation location from to skills achievements]
        required_fields = %i[title organisation location from skills achievements]
        experience_fields = experience.keys

        unless experience_fields.all? { |field| allowed_fields.include?(field) }
          raise Error, "Experiences section: Experience contains invalid fields"
        end

        required_fields.each do |field|
          raise Error, "Experiences section: Experience missing required field '#{field}'" unless experience_fields.include?(field)
        end

        raise Error, "Experiences section: Experience field 'title' must be a string" unless experience[:title].is_a?(String)
        raise Error, "Experiences section: Experience field 'organisation' must be a string" unless experience[:organisation].is_a?(String)

        validate_location(experience[:location], "Experiences section")

        raise Error, "Experiences section: Experience field 'from' must be a hash" unless experience[:from].is_a?(Hash)
        validate_date_format(experience[:from], "Experiences section")

        if experience.key?(:to)
          raise Error, "Experiences section: Experience field 'to' must be a hash" unless experience[:to].is_a?(Hash)
          validate_date_format(experience[:to], "Experiences section")
        end

        raise Error, "Experiences section: Experience field 'skills' must be an array" unless experience[:skills].is_a?(Array)
        experience[:skills].each do |skill|
          raise Error, "Experiences section: Each experience skill item must be a string" unless skill.is_a?(String)
        end

        raise Error, "Experiences section: Experience field 'achievements' must be an array" unless experience[:achievements].is_a?(Array)
        experience[:achievements].each do |achievement|
          raise Error, "Experiences section: Each experience achievement item must be a string" unless achievement.is_a?(String)
        end
      end
    end

    def validate_date_format(date, section)
      allowed_fields = %i[month year]
      date_fields = date.keys

      unless date_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "#{section}: Date contains invalid fields"
      end

      allowed_fields.each do |field|
        raise Error, "#{section}: Date missing required field '#{field}'" unless date_fields.include?(field)
        raise Error, "#{section}: Date field '#{field}' must be an integer" unless date[field].is_a?(Integer)
      end
    end
  end
end
