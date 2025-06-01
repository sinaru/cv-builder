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

      error = assert_raises(Kamisaku::Error) { validator.validate! }

      assert_equal "Invalid version", error.message
    end

    def test_validate_profile_success
      validator = ContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_profile_missing
      invalid_content = @valid_content.except(:profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Kamisaku::Error) { validator.validate! }

      assert_equal "Missing profile", error.message
    end

    def test_validate_profile_not_a_hash
      invalid_content = @valid_content.merge(profile: "invalid_profile")
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Kamisaku::Error) { validator.validate! }

      assert_equal "Profile must be a hash", error.message
    end

    def test_validate_profile_invalid_fields
      invalid_profile = @valid_content[:profile].merge(age: 30)
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Kamisaku::Error) { validator.validate! }

      assert_equal "Profile contains invalid fields", error.message
    end

    def test_validate_profile_missing_fields
      invalid_profile = { name: "Foo", title: "Some Job Title" }
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Kamisaku::Error) { validator.validate! }

      assert_equal "Profile must contain exactly the fields: name, title, about", error.message
    end

    def test_validate_profile_non_string_values
      invalid_profile = { name: "Foo", title: "Some Job Title", about: 123 }
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Kamisaku::Error) { validator.validate! }

      assert_equal "Profile field 'about' must be a string", error.message
    end

  end
end
