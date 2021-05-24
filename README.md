# Orbit Activities Helper Library for Ruby

![Build Status](https://github.com/orbit-love/ruby-orbit-activities/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/orbit_activities.svg)](https://badge.fury.io/rb/orbit_activities)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](code_of_conduct.md)

> Orbit API helper library for Ruby. <br>This client can create, read, update and delete activities in your Orbit workspace.

<img src="https://github.com/orbit-love/js-orbit-activities/blob/bc4ce38a34af95e40b2c3e54ba44d3df6b3d3aac/.github/logo.png" alt="Orbit" style="max-width: 300px; margin: 2em 0;">

## Package Usage

### Installation

To install this integration in a standalone app, add the gem to your `Gemfile`:

```ruby
gem "orbit_activities"
```

Then, run `bundle install` from your terminal.

### Usage

#### Create an Activity

To create an activity:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    action: "new_activity",
    body: # The custom activity object in JSON format, see Orbit API docs for reference
)
```
#### Update an Activity

To update an activity:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    action: "update_activity",
    activity_id: # The ID of the activity to be updated,
    member_id: # The ID of the member the activity is attached to,
    body: # The custom activity object in JSON format, see Orbit API docs for reference
)
```
#### Delete an Activity

To delete an activity:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    action: "delete_activity",
    activity_id: # The ID of the activity to be updated,
    member_id: # The ID of the member the activity is attached to
)
```
#### List Activities

To list activities:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    action: "list_activities",
    filters: # Any filters on the request in JSON format, see Orbit API docs for reference
)
```
#### Get Specific Activity

To get a specific activity:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    action: "get_activity",
    activity_id: # The ID of the actiivity
)
```
#### Get Member Activities

To get activities associated with a specific member:

```ruby
OrbitActivities::Request.new(
    api_key: # Your Orbit API key,
    workspace_id: # Your Orbit workspace ID,
    action: "list_member_activities",
    activity_id: # The ID of the actiivity,
    member_id: # The ID of the member,
    filters: # Any filters on the request in JSON format, see Orbit API docs for reference
)
```

For details on the data structures the Orbit API expects, refer to the [Orbit API Documentation](https://docs.orbit.love/reference).

## Contributing

We 💜 contributions from everyone! Check out the [Contributing Guidelines](CONTRIBUTING.md) for more information.

## License

This is available as open source under the terms of the [MIT License](LICENSE).

## Code of Conduct

This project uses the [Contributor Code of Conduct](CODE_OF_CONDUCT.md). We ask everyone to please adhere by its guidelines.
