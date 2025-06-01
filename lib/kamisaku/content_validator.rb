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
  end
end
