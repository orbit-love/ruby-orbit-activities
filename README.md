# Orbit API Create Custom Activities Helper

![Build Status](https://github.com/orbit-love/ruby-create-activities/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/orbit_activities.svg)](https://badge.fury.io/rb/orbit_activities)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](code_of_conduct.md)

> This is a Ruby gem that can be included in any Ruby application to take care of the logic of interacting with the Orbit API to create custom activities.

<hr />

## Package Usage

### Installation

To install this integration in a standalone app, add the gem to your `Gemfile`:

```ruby
gem "orbit_activities"
```

Then, run `bundle install` from your terminal.

### Send Custom Activity

To send a custom activity to Orbit using the gem, instantiate a new instance of the `Request` class:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    body: # The custom activity object
)
```

For details on the data structure the Orbit API expects for a custom activity object, refer to the [Orbit API Documentation](https://docs.orbit.love/reference#post_-workspace-id-activities).

## Contributing

We 💜 contributions from everyone! Check out the [Contributing Guidelines](CONTRIBUTING.md) for more information.

## License

This is available as open source under the terms of the [MIT License](LICENSE).

## Code of Conduct

This project uses the [Contributor Code of Conduct](CODE_OF_CONDUCT.md). We ask everyone to please adhere by its guidelines.