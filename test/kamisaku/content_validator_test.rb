require "test_helper"

module Kamisaku
  class ContentValidatorTest < Minitest::Test
    def setup
      @valid_content = {
        version: 1,
        profile: {
          name: "Foo",
          title: "Some Job Title",
          about: "Some Job about text"
        },
        contact: {
          github: "foobar",
          mobile: "+1 123 456 7890",
          linkedin: "foobar",
          website: "http://foobar.com",
          email: "someone@site.com",
          location: {
            country: "USA",
            city: "New York",
          }
        }
      }
    end

    def test_validate_version_success
      validator = ContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_version_failure
      invalid_content = @valid_content.merge(version: 2)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Invalid version", error.message
    end

    def test_validate_profile_success
      validator = ContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_profile_missing
      invalid_content = @valid_content.except(:profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing profile", error.message
    end

    def test_validate_profile_not_a_hash
      invalid_content = @valid_content.merge(profile: "invalid_profile")
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile must be a hash", error.message
    end

    def test_validate_profile_invalid_fields
      invalid_profile = @valid_content[:profile].merge(age: 30)
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile contains invalid fields", error.message
    end

    def test_validate_profile_missing_fields
      invalid_profile = { name: "Foo", title: "Some Job Title" }
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile must contain exactly the fields: name, title, about", error.message
    end

    def test_validate_profile_non_string_values
      invalid_profile = { name: "Foo", title: "Some Job Title", about: 123 }
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile field 'about' must be a string", error.message
    end

    def test_validate_contact_success
      validator = ContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_missing
      invalid_content = @valid_content.except(:contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing contact", error.message
    end

    def test_validate_contact_not_a_hash
      invalid_content = @valid_content.merge(contact: "invalid_contact")
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact must be a hash", error.message
    end

    def test_validate_contact_invalid_fields
      invalid_contact = @valid_content[:contact].merge(extra_field: "invalid")
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact contains invalid fields", error.message
    end

    def test_validate_contact_missing_field
      invalid_contact = @valid_content[:contact].except(:email)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact missing required field 'email'", error.message
    end

    def test_validate_contact_field_non_string_value
      invalid_contact = @valid_content[:contact].merge(email: 123)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact field 'email' must be a string", error.message
    end

    def test_validate_contact_location_success
      validator = ContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_location_missing
      invalid_contact = @valid_content[:contact].except(:location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact missing required field 'location'", error.message
    end

    def test_validate_contact_location_not_a_hash
      invalid_contact = @valid_content[:contact].merge(location: "invalid_location")
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Location must be a hash", error.message
    end

    def test_validate_contact_location_invalid_fields
      invalid_location = @valid_content[:contact][:location].merge(extra_field: "invalid")
      invalid_contact = @valid_content[:contact].merge(location: invalid_location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Location contains invalid fields", error.message
    end

    def test_validate_contact_location_missing_field
      invalid_location = @valid_content[:contact][:location].except(:city)
      invalid_contact = @valid_content[:contact].merge(location: invalid_location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Location missing required field 'city'", error.message
    end

    def test_validate_contact_location_field_non_string_value
      invalid_location = @valid_content[:contact][:location].merge(city: 123)
      invalid_contact = @valid_content[:contact].merge(location: invalid_location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Location field 'city' must be a string", error.message
    end
  end
end
