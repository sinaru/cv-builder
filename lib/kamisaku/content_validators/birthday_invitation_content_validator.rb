module Kamisaku
  class BirthdayInvitationContentValidator < BaseContentValidator
    TEMPLATES = %w[
      dino
    ].freeze

    def validate!
      validate_party_details
      validate_venue
      validate_contact_info
      validate_rsvp
      validate_special_instructions if data[:special_instructions]
      validate_activities if data[:activities]
    end

    private

    def validate_party_details
      raise Error, "Missing party_details" unless data[:party_details]
      raise Error, "party_details must be a hash" unless data[:party_details].is_a?(Hash)

      required_fields = %i[person_name age date start_time]
      allowed_fields = %i[person_name age date start_time end_time theme]
      party_fields = data[:party_details].keys

      unless party_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "party_details contains invalid fields"
      end

      required_fields.each do |field|
        unless party_fields.include?(field)
          raise Error, "party_details missing required field '#{field}'"
        end
      end

      validate_string_field(data[:party_details][:person_name], "party_details", "person_name")
      validate_integer_field(data[:party_details][:age], "party_details", "age")
      validate_date(data[:party_details][:date], "party_details")
      validate_string_field(data[:party_details][:start_time], "party_details", "start_time")

      if data[:party_details][:end_time]
        validate_string_field(data[:party_details][:end_time], "party_details", "end_time")
      end

      if data[:party_details][:theme]
        validate_string_field(data[:party_details][:theme], "party_details", "theme")
      end
    end

    def validate_venue
      raise Error, "Missing venue" unless data[:venue]
      raise Error, "venue must be a hash" unless data[:venue].is_a?(Hash)

      required_fields = %i[address]
      allowed_fields = %i[name address additional_instructions]
      venue_fields = data[:venue].keys

      unless venue_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "venue contains invalid fields"
      end

      required_fields.each do |field|
        unless venue_fields.include?(field)
          raise Error, "venue missing required field '#{field}'"
        end
      end

      validate_string_field(data[:venue][:address], "venue", "address")

      if data[:venue][:name]
        validate_string_field(data[:venue][:name], "venue", "name")
      end

      if data[:venue][:additional_instructions]
        validate_string_field(data[:venue][:additional_instructions], "venue", "additional_instructions")
      end
    end

    def validate_contact_info
      raise Error, "Missing contact_info" unless data[:contact_info]
      raise Error, "contact_info must be a hash" unless data[:contact_info].is_a?(Hash)

      required_fields = %i[host_name phone]
      allowed_fields = %i[host_name phone email]
      contact_fields = data[:contact_info].keys

      unless contact_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "contact_info contains invalid fields"
      end

      required_fields.each do |field|
        unless contact_fields.include?(field)
          raise Error, "contact_info missing required field '#{field}'"
        end
      end

      validate_string_field(data[:contact_info][:host_name], "contact_info", "host_name")
      validate_string_field(data[:contact_info][:phone], "contact_info", "phone")

      if data[:contact_info][:email]
        validate_string_field(data[:contact_info][:email], "contact_info", "email")
      end
    end

    def validate_rsvp
      raise Error, "Missing rsvp" unless data[:rsvp]
      raise Error, "rsvp must be a hash" unless data[:rsvp].is_a?(Hash)

      required_fields = %i[deadline method contact]
      rsvp_fields = data[:rsvp].keys

      unless rsvp_fields.all? { |field| required_fields.include?(field) }
        raise Error, "rsvp contains invalid fields"
      end

      required_fields.each do |field|
        unless rsvp_fields.include?(field)
          raise Error, "rsvp missing required field '#{field}'"
        end
      end

      validate_date(data[:rsvp][:deadline], "rsvp")
      validate_string_field(data[:rsvp][:method], "rsvp", "method")
      validate_string_field(data[:rsvp][:contact], "rsvp", "contact")
    end

    def validate_special_instructions
      raise Error, "special_instructions must be a hash" unless data[:special_instructions].is_a?(Hash)

      allowed_fields = %i[what_to_bring dress_code food_allergies_note gift_preferences parking_info weather_backup]
      special_fields = data[:special_instructions].keys

      unless special_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "special_instructions contains invalid fields"
      end

      data[:special_instructions].each do |field, value|
        validate_string_field(value, "special_instructions", field.to_s)
      end
    end

    def validate_activities
      raise Error, "activities must be a hash" unless data[:activities].is_a?(Hash)

      allowed_fields = %i[main_activities entertainment]
      activities_fields = data[:activities].keys

      unless activities_fields.all? { |field| allowed_fields.include?(field) }
        raise Error, "activities contains invalid fields"
      end

      if data[:activities][:main_activities]
        validate_array_of_strings(data[:activities][:main_activities], "activities", "main_activities")
      end

      if data[:activities][:entertainment]
        validate_string_field(data[:activities][:entertainment], "activities", "entertainment")
      end
    end

    def validate_date(date, section)
      raise Error, "#{section}: date must be a hash" unless date.is_a?(Hash)

      required_fields = %i[day month year]
      date_fields = date.keys

      unless date_fields.all? { |field| required_fields.include?(field) }
        raise Error, "#{section}: date contains invalid fields"
      end

      required_fields.each do |field|
        unless date_fields.include?(field)
          raise Error, "#{section}: date missing required field '#{field}'"
        end
        validate_integer_field(date[field], section, "date.#{field}")
      end

      validate_day_range(date[:day], section)
      validate_month_range(date[:month], section)
    end

    def validate_string_field(value, section, field)
      unless value.is_a?(String)
        raise Error, "#{section}: field '#{field}' must be a string"
      end
    end

    def validate_integer_field(value, section, field)
      unless value.is_a?(Integer)
        raise Error, "#{section}: field '#{field}' must be an integer"
      end
    end

    def validate_array_of_strings(value, section, field)
      unless value.is_a?(Array)
        raise Error, "#{section}: field '#{field}' must be an array"
      end

      value.each do |item|
        unless item.is_a?(String)
          raise Error, "#{section}: each item in '#{field}' must be a string"
        end
      end
    end

    def validate_day_range(day, section)
      unless day.between?(1, 31)
        raise Error, "#{section}: day must be between 1-31"
      end
    end

    def validate_month_range(month, section)
      unless month.between?(1, 12)
        raise Error, "#{section}: month must be between 1-12"
      end
    end
  end
end
