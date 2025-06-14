require "test_helper"

module Kamisaku
  class ResumeContentValidatorTest < Minitest::Test
    def setup
      @valid_content = {
        version: 1,
        profile: {
          photo_url: "https://somesite.com/my_photo.jpg",
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
            city: "New York"
          }
        },
        skills: [
          {
            name: "Artificial Intelligence",
            items: [
              "Python",
              "Machine Learning",
              "Deep Learning",
              "TensorFlow",
              "PyTorch",
              "Natural Language Processing",
              "Computer Vision"
            ]
          }
        ],
        experiences: [
          {
            title: "Job title name",
            organisation: "Company name",
            location: {
              country: "USA",
              city: "New York"
            },
            from: {
              month: 1,
              year: 2020
            },
            to: {
              month: 4,
              year: 2024
            },
            skills: [
              "PyTorch",
              "Machine Learning"
            ],
            achievements: [
              "Senior engineer in developing the technical environment",
              "Led multiple successful projects from inception to completion",
              "Mentored junior developers and improved team productivity"
            ]
          }
        ]
      }
    end

    def test_validate_version_success
      validator = ResumeContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_version_failure
      invalid_content = @valid_content.merge(version: 2)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Invalid version", error.message
    end

    def test_validate_profile_success
      validator = ResumeContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_profile_missing
      invalid_content = @valid_content.except(:profile)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing profile", error.message
    end

    def test_validate_profile_not_a_hash
      invalid_content = @valid_content.merge(profile: "invalid_profile")
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile must be a hash", error.message
    end

    def test_validate_profile_invalid_fields
      invalid_profile = @valid_content[:profile].merge(age: 30)
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile contains invalid fields", error.message
    end

    def test_validate_profile_missing_fields
      invalid_profile = {name: "Foo", title: "Some Job Title"}
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile must contain exactly the fields: name, title, about, photo_url", error.message
    end

    def test_validate_profile_non_string_values
      invalid_profile = {name: "Foo", title: "Some Job Title", about: 123}
      invalid_content = @valid_content.merge(profile: invalid_profile)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Profile field 'about' must be a string", error.message
    end

    def test_validate_photo_url_missing
      content_without_photo_url = @valid_content.merge(profile: @valid_content[:profile].except(:photo_url))
      validator = ResumeContentValidator.new(content_hash: content_without_photo_url)

      assert_silent { validator.validate! }
    end

    def test_validate_photo_url_empty_string
      content_with_empty_photo_url = @valid_content.merge(profile: @valid_content[:profile].merge(photo_url: ""))
      validator = ResumeContentValidator.new(content_hash: content_with_empty_photo_url)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Invalid photo_url. It must be an HTTP/HTTPS URL ending with .jpg or .jpeg", error.message
    end

    def test_validate_photo_url_invalid_format
      invalid_photo_url_content = @valid_content.merge(profile: @valid_content[:profile].merge(photo_url: "invalid_url"))
      validator = ResumeContentValidator.new(content_hash: invalid_photo_url_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Invalid photo_url. It must be an HTTP/HTTPS URL ending with .jpg or .jpeg", error.message
    end

    def test_validate_photo_url_invalid_protocol
      invalid_photo_url_content = @valid_content.merge(profile: @valid_content[:profile].merge(photo_url: "ftp://example.com/image.jpg"))
      validator = ResumeContentValidator.new(content_hash: invalid_photo_url_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Invalid photo_url. It must be an HTTP/HTTPS URL ending with .jpg or .jpeg", error.message
    end

    def test_validate_photo_url_invalid_file_extension
      invalid_photo_url_content = @valid_content.merge(profile: @valid_content[:profile].merge(photo_url: "https://example.com/photo.png"))
      validator = ResumeContentValidator.new(content_hash: invalid_photo_url_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Invalid photo_url. It must be an HTTP/HTTPS URL ending with .jpg or .jpeg", error.message
    end

    def test_validate_photo_url_valid_https
      valid_photo_url_content = @valid_content.merge(profile: @valid_content[:profile].merge(photo_url: "https://example.com/photo.jpg"))
      validator = ResumeContentValidator.new(content_hash: valid_photo_url_content)

      assert_silent { validator.validate! }
    end

    def test_validate_photo_url_valid_http
      valid_photo_url_content = @valid_content.merge(profile: @valid_content[:profile].merge(photo_url: "http://example.com/photo.jpeg"))
      validator = ResumeContentValidator.new(content_hash: valid_photo_url_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_success
      validator = ResumeContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_missing
      invalid_content = @valid_content.except(:contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing contact", error.message
    end

    def test_validate_contact_not_a_hash
      invalid_content = @valid_content.merge(contact: "invalid_contact")
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact must be a hash", error.message
    end

    def test_validate_contact_invalid_fields
      invalid_contact = @valid_content[:contact].merge(extra_field: "invalid")
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact contains invalid fields", error.message
    end

    def test_validate_contact_empty_hash
      invalid_content = @valid_content.merge(contact: {})
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_field_non_string_value
      invalid_contact = @valid_content[:contact].merge(email: 123)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact field 'email' must be a string", error.message
    end

    def test_validate_contact_location_success
      validator = ResumeContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_location_missing
      invalid_contact = @valid_content[:contact].except(:location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_location_not_a_hash
      invalid_contact = @valid_content[:contact].merge(location: "invalid_location")
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact section: Location must be a hash", error.message
    end

    def test_validate_contact_location_invalid_fields
      invalid_location = @valid_content[:contact][:location].merge(extra_field: "invalid")
      invalid_contact = @valid_content[:contact].merge(location: invalid_location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact section: Location contains invalid fields", error.message
    end

    def test_validate_contact_location_missing_field
      invalid_location = @valid_content[:contact][:location].except(:city)
      invalid_contact = @valid_content[:contact].merge(location: invalid_location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact section: Location missing required field 'city'", error.message
    end

    def test_validate_contact_location_field_non_string_value
      invalid_location = @valid_content[:contact][:location].merge(city: 123)
      invalid_contact = @valid_content[:contact].merge(location: invalid_location)
      invalid_content = @valid_content.merge(contact: invalid_contact)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Contact section: Location field 'city' must be a string", error.message
    end

    def test_validate_skills_success
      validator = ResumeContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_skills_optional
      content_without_skills = @valid_content.except(:skills)
      validator = ResumeContentValidator.new(content_hash: content_without_skills)

      assert_silent { validator.validate! }
    end

    def test_validate_skills_not_array
      invalid_content = @valid_content.merge(skills: "not_an_array")
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Skills must be an array", error.message
    end

    def test_validate_skills_item_not_hash
      invalid_skills = ["not_a_hash"]
      invalid_content = @valid_content.merge(skills: invalid_skills)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Each skill must be a hash", error.message
    end

    def test_validate_skills_missing_field
      invalid_skill = {name: "Artificial Intelligence"}
      invalid_content = @valid_content.merge(skills: [invalid_skill])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Skills section: Skill missing required field 'items'", error.message
    end

    def test_validate_skills_field_not_string
      invalid_skill = {name: 123, items: ["Python"]}
      invalid_content = @valid_content.merge(skills: [invalid_skill])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Skills section: Skill field 'name' must be a string", error.message
    end

    def test_validate_skills_items_not_array
      invalid_skill = {name: "Artificial Intelligence", items: "not_an_array"}
      invalid_content = @valid_content.merge(skills: [invalid_skill])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Skills section: Skill field 'items' must be an array", error.message
    end

    def test_validate_skills_item_not_string
      invalid_skill = {name: "Artificial Intelligence", items: [123]}
      invalid_content = @valid_content.merge(skills: [invalid_skill])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Skills section: Each skill item must be a string", error.message
    end

    def test_validate_experiences_success
      validator = ResumeContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_experiences_optional
      content_without_experiences = @valid_content.except(:experiences)
      validator = ResumeContentValidator.new(content_hash: content_without_experiences)

      assert_silent { validator.validate! }
    end

    def test_validate_experiences_not_array
      invalid_content = @valid_content.merge(experiences: "not_an_array")
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences must be an array", error.message
    end

    def test_validate_experiences_item_not_hash
      invalid_experiences = ["not_a_hash"]
      invalid_content = @valid_content.merge(experiences: invalid_experiences)
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Each experience must be a hash", error.message
    end

    def test_validate_experiences_missing_required_fields
      invalid_experience = @valid_content[:experiences][0].except(:organisation)
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Experience missing required field 'organisation'", error.message
    end

    def test_validate_experiences_invalid_location
      invalid_experience = @valid_content[:experiences][0].merge(location: "invalid_location")
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Location must be a hash", error.message
    end

    def test_validate_experiences_invalid_from_field
      invalid_experience = @valid_content[:experiences][0].merge(from: "invalid_from")
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Experience field 'from' must be a hash", error.message
    end

    def test_validate_experiences_invalid_to_field
      invalid_experience = @valid_content[:experiences][0].merge(to: "invalid_to")
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Experience field 'to' must be a hash", error.message
    end

    def test_validate_experiences_invalid_date_format
      invalid_experience = @valid_content[:experiences][0].merge(from: {month: "invalid_month", year: 2020})
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Date field 'month' must be an integer", error.message
    end

    def test_validate_experiences_missing_date_field
      invalid_experience = @valid_content[:experiences][0].merge(from: {year: 2020})
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Date missing required field 'month'", error.message
    end

    def test_validate_experiences_skills_not_array
      invalid_experience = @valid_content[:experiences][0].merge(skills: "not_an_array")
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Experience field 'skills' must be an array", error.message
    end

    def test_validate_experiences_achievements_not_array
      invalid_experience = @valid_content[:experiences][0].merge(achievements: "not_an_array")
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Experience field 'achievements' must be an array", error.message
    end

    def test_validate_experiences_achievement_item_not_string
      invalid_experience = @valid_content[:experiences][0].merge(achievements: [123])
      invalid_content = @valid_content.merge(experiences: [invalid_experience])
      validator = ResumeContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Experiences section: Each experience achievement item must be a string", error.message
    end
  end
end
