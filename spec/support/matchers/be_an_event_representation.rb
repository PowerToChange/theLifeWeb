RSpec::Matchers.define :be_an_event_representation do |event|
  match do |json|
    event_attributes = event.sliced_attributes %w[
      id
      user_id
      friend_id
      activity_id
      prayer_requested
      threshold_id
    ]

    event_accessors = event.sliced_accessors %w[
      description
    ]

    response_attributes = event_attributes.merge(event_accessors)

    json.should be
    json.should include_attributes(response_attributes)
  end
end
