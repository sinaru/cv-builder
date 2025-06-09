require "test_helper"

module Kamisaku
  class BirthdayInvitationContentValidatorTest < Minitest::Test
    def setup
      @valid_content = {
        party_details: {
          person_name: "Emma",
          age: 8,
          date: {
            day: 15,
            month: 6,
            year: 2025
          },
          start_time: "2:00 PM",
          end_time: "5:00 PM",
          theme: "Dinosaur Adventure"
        },
        venue: {
          name: "Chuck E. Cheese",
          address: "123 Main Street, New York, NY 10001",
          additional_instructions: "Use the side entrance for party room access"
        },
        contact_info: {
          host_name: "Sarah Johnson",
          phone: "+1 (555) 123-4567",
          email: "sarah.johnson@email.com"
        },
        rsvp: {
          deadline: {
            day: 10,
            month: 6,
            year: 2025
          },
          method: "phone",
          contact: "Sarah at (555) 123-4567"
        },
        special_instructions: {
          what_to_bring: "Please bring a swimsuit for water activities",
          dress_code: "Casual clothes that can get messy",
          food_allergies_note: "Please let us know about any food allergies",
          gift_preferences: "Books or art supplies would be wonderful",
          parking_info: "Free parking available in the lot behind the building",
          weather_backup: "Party will move indoors to the community center if it rains"
        },
        activities: {
          main_activities: ["Treasure hunt", "Dinosaur dig", "Face painting"],
          entertainment: "Magic show by Amazing Mike at 3:30 PM"
        }
      }
    end

    def teardown
      # Do nothing
    end

    def test_validate_party_details_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_party_details_missing
      invalid_content = @valid_content.except(:party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing party_details", error.message
    end

    def test_validate_party_details_not_a_hash
      invalid_content = @valid_content.merge(party_details: "invalid_party_details")
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details must be a hash", error.message
    end

    def test_validate_party_details_invalid_fields
      invalid_party_details = @valid_content[:party_details].merge(extra_field: "invalid")
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details contains invalid fields", error.message
    end

    def test_validate_party_details_missing_required_fields
      invalid_party_details = @valid_content[:party_details].except(:person_name)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details missing required field 'person_name'", error.message
    end

    def test_validate_party_details_person_name_not_string
      invalid_party_details = @valid_content[:party_details].merge(person_name: 123)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: field 'person_name' must be a string", error.message
    end

    def test_validate_party_details_age_not_integer
      invalid_party_details = @valid_content[:party_details].merge(age: "eight")
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: field 'age' must be an integer", error.message
    end

    def test_validate_party_details_optional_fields_success
      minimal_party_details = {
        person_name: "Emma",
        age: 8,
        date: {
          day: 15,
          month: 6,
          year: 2025
        },
        start_time: "2:00 PM"
      }
      content_with_minimal_details = @valid_content.merge(party_details: minimal_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: content_with_minimal_details)

      assert_silent { validator.validate! }
    end

    def test_validate_venue_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_venue_missing
      invalid_content = @valid_content.except(:venue)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing venue", error.message
    end

    def test_validate_venue_not_a_hash
      invalid_content = @valid_content.merge(venue: "invalid_venue")
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "venue must be a hash", error.message
    end

    def test_validate_venue_missing_required_field
      invalid_venue = @valid_content[:venue].except(:address)
      invalid_content = @valid_content.merge(venue: invalid_venue)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "venue missing required field 'address'", error.message
    end

    def test_validate_venue_optional_fields_success
      minimal_venue = {address: "123 Main Street, New York, NY 10001"}
      content_with_minimal_venue = @valid_content.merge(venue: minimal_venue)
      validator = BirthdayInvitationContentValidator.new(content_hash: content_with_minimal_venue)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_info_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_contact_info_missing
      invalid_content = @valid_content.except(:contact_info)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing contact_info", error.message
    end

    def test_validate_contact_info_not_a_hash
      invalid_content = @valid_content.merge(contact_info: "invalid_contact_info")
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "contact_info must be a hash", error.message
    end

    def test_validate_contact_info_missing_required_field
      invalid_contact_info = @valid_content[:contact_info].except(:host_name)
      invalid_content = @valid_content.merge(contact_info: invalid_contact_info)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "contact_info missing required field 'host_name'", error.message
    end

    def test_validate_contact_info_optional_email_success
      minimal_contact_info = {
        host_name: "Sarah Johnson",
        phone: "+1 (555) 123-4567"
      }
      content_with_minimal_contact = @valid_content.merge(contact_info: minimal_contact_info)
      validator = BirthdayInvitationContentValidator.new(content_hash: content_with_minimal_contact)

      assert_silent { validator.validate! }
    end

    def test_validate_rsvp_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_rsvp_missing
      invalid_content = @valid_content.except(:rsvp)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "Missing rsvp", error.message
    end

    def test_validate_rsvp_not_a_hash
      invalid_content = @valid_content.merge(rsvp: "invalid_rsvp")
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "rsvp must be a hash", error.message
    end

    def test_validate_rsvp_missing_required_field
      invalid_rsvp = @valid_content[:rsvp].except(:deadline)
      invalid_content = @valid_content.merge(rsvp: invalid_rsvp)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "rsvp missing required field 'deadline'", error.message
    end

    def test_validate_rsvp_invalid_fields
      invalid_rsvp = @valid_content[:rsvp].merge(extra_field: "invalid")
      invalid_content = @valid_content.merge(rsvp: invalid_rsvp)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "rsvp contains invalid fields", error.message
    end

    def test_validate_date_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_date_not_a_hash
      invalid_party_details = @valid_content[:party_details].merge(date: "invalid_date")
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: date must be a hash", error.message
    end

    def test_validate_date_missing_required_field
      invalid_date = @valid_content[:party_details][:date].except(:day)
      invalid_party_details = @valid_content[:party_details].merge(date: invalid_date)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: date missing required field 'day'", error.message
    end

    def test_validate_date_invalid_fields
      invalid_date = @valid_content[:party_details][:date].merge(extra_field: "invalid")
      invalid_party_details = @valid_content[:party_details].merge(date: invalid_date)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: date contains invalid fields", error.message
    end

    def test_validate_date_day_not_integer
      invalid_date = @valid_content[:party_details][:date].merge(day: "fifteen")
      invalid_party_details = @valid_content[:party_details].merge(date: invalid_date)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: field 'date.day' must be an integer", error.message
    end

    def test_validate_date_day_out_of_range
      invalid_date = @valid_content[:party_details][:date].merge(day: 32)
      invalid_party_details = @valid_content[:party_details].merge(date: invalid_date)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: day must be between 1-31", error.message
    end

    def test_validate_date_month_out_of_range
      invalid_date = @valid_content[:party_details][:date].merge(month: 13)
      invalid_party_details = @valid_content[:party_details].merge(date: invalid_date)
      invalid_content = @valid_content.merge(party_details: invalid_party_details)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "party_details: month must be between 1-12", error.message
    end

    def test_validate_special_instructions_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_special_instructions_optional
      content_without_special_instructions = @valid_content.except(:special_instructions)
      validator = BirthdayInvitationContentValidator.new(content_hash: content_without_special_instructions)

      assert_silent { validator.validate! }
    end

    def test_validate_special_instructions_not_a_hash
      invalid_content = @valid_content.merge(special_instructions: "invalid_special_instructions")
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "special_instructions must be a hash", error.message
    end

    def test_validate_special_instructions_invalid_fields
      invalid_special_instructions = @valid_content[:special_instructions].merge(extra_field: "invalid")
      invalid_content = @valid_content.merge(special_instructions: invalid_special_instructions)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "special_instructions contains invalid fields", error.message
    end

    def test_validate_special_instructions_field_not_string
      invalid_special_instructions = @valid_content[:special_instructions].merge(what_to_bring: 123)
      invalid_content = @valid_content.merge(special_instructions: invalid_special_instructions)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "special_instructions: field 'what_to_bring' must be a string", error.message
    end

    def test_validate_activities_success
      validator = BirthdayInvitationContentValidator.new(content_hash: @valid_content)

      assert_silent { validator.validate! }
    end

    def test_validate_activities_optional
      content_without_activities = @valid_content.except(:activities)
      validator = BirthdayInvitationContentValidator.new(content_hash: content_without_activities)

      assert_silent { validator.validate! }
    end

    def test_validate_activities_not_a_hash
      invalid_content = @valid_content.merge(activities: "invalid_activities")
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "activities must be a hash", error.message
    end

    def test_validate_activities_invalid_fields
      invalid_activities = @valid_content[:activities].merge(extra_field: "invalid")
      invalid_content = @valid_content.merge(activities: invalid_activities)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "activities contains invalid fields", error.message
    end

    def test_validate_activities_main_activities_not_array
      invalid_activities = @valid_content[:activities].merge(main_activities: "not_an_array")
      invalid_content = @valid_content.merge(activities: invalid_activities)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "activities: field 'main_activities' must be an array", error.message
    end

    def test_validate_activities_main_activities_item_not_string
      invalid_activities = @valid_content[:activities].merge(main_activities: [123, "Valid activity"])
      invalid_content = @valid_content.merge(activities: invalid_activities)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "activities: each item in 'main_activities' must be a string", error.message
    end

    def test_validate_activities_entertainment_not_string
      invalid_activities = @valid_content[:activities].merge(entertainment: 123)
      invalid_content = @valid_content.merge(activities: invalid_activities)
      validator = BirthdayInvitationContentValidator.new(content_hash: invalid_content)

      error = assert_raises(Error) { validator.validate! }

      assert_equal "activities: field 'entertainment' must be a string", error.message
    end

    def test_validate_with_minimal_required_data
      minimal_content = {
        party_details: {
          person_name: "Emma",
          age: 8,
          date: {
            day: 15,
            month: 6,
            year: 2025
          },
          start_time: "2:00 PM"
        },
        venue: {
          address: "123 Main Street, New York, NY 10001"
        },
        contact_info: {
          host_name: "Sarah Johnson",
          phone: "+1 (555) 123-4567"
        },
        rsvp: {
          deadline: {
            day: 10,
            month: 6,
            year: 2025
          },
          method: "phone",
          contact: "Sarah at (555) 123-4567"
        }
      }
      validator = BirthdayInvitationContentValidator.new(content_hash: minimal_content)

      assert_silent { validator.validate! }
    end
  end
end
