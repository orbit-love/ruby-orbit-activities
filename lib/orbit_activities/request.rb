# frozen_string_literal: true

require_relative "http"

module OrbitActivities
  class Request
    attr_reader :api_key, :workspace_id, :user_agent, :action, :body, :filters, :member_id, :activity_id
    attr_accessor :response

    def initialize(params = {})
      @action = params.fetch(:action)
      @api_key = params.fetch(:api_key)
      @workspace_id = params.fetch(:workspace_id)
      @user_agent = params.fetch(:user_agent, "ruby-orbit-activities/#{OrbitActivities::VERSION}")
      @body = params.fetch(:body, nil)
      @filters = params.fetch(:filters, nil)
      @member_id = params.fetch(:member_id, nil)
      @activity_id = params.fetch(:activity_id, nil)
      @response = nil

      after_initialize!
    end

    def after_initialize!
      case @action
      when "new_activity"
        new_activity
      when "list_activities"
        list_activities
      when "get_activity"
        get_activity
      when "list_member_activities"
        list_member_activities
      when "create_post"
        create_post
      when "delete_post"
        delete_post
      when "update_activity"
        update_activity
      when "latest_activity_timestamp"
        latest_activity_timestamp
      else
        raise ArgumentError,
              "Activity type is unrecognized. Must be one of: new_activity, list_activities, get_activity, list_member_activities, create_post, delete_post, update_activity"
      end
    end

    def new_activity
      @response = OrbitActivities::HTTP.post(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities",
        user_agent: @user_agent,
        api_key: @api_key,
        body: @body
      )
    end

    def list_activities
      @response = OrbitActivities::HTTP.get(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities",
        user_agent: @user_agent,
        api_key: @api_key,
        filters: @filters
      )
    end

    def latest_activity_timestamp
      filters = {
        items: 10,
        direction: "DESC"
      }
      filters.merge!(@filters)

      response = OrbitActivities::HTTP.get(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities",
        user_agent: @user_agent,
        api_key: @api_key,
        filters: filters
      )

      return nil if response["data"].nil? || response["data"].empty?

      @response = response["data"][0]["attributes"]["created_at"]
    end

    def get_activity
      @response = OrbitActivities::HTTP.get(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities/#{@activity_id}",
        user_agent: @user_agent,
        api_key: @api_key
      )
    end

    def list_member_activities
      @response = OrbitActivities::HTTP.get(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities",
        user_agent: @user_agent,
        api_key: @api_key,
        filters: @filters
      )
    end

    def create_post
      @response = OrbitActivities::HTTP.post(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities",
        user_agent: @user_agent,
        api_key: @api_key,
        body: @body
      )
    end

    def delete_post
      @response = OrbitActivities::HTTP.delete(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities/#{@activity_id}",
        user_agent: @user_agent,
        api_key: @api_key
      )
    end

    def update_activity
      @response = OrbitActivities::HTTP.put(
        url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities/#{@activity_id}",
        user_agent: @user_agent,
        api_key: @api_key,
        body: @body
      )
    end
  end
end
