# frozen_string_literal: true

require_relative "http"

module OrbitActivities
    class Request
        attr_reader :api_key, :workspace_id, :user_agent, :action, :body, :filters, :member_id, :activity_id

        def initialize(params = {})
            @action = params.fetch(:action)
            @api_key = params.fetch(:api_key)
            @workspace_id = params.fetch(:workspace_id)
            @user_agent = params.fetch(:user_agent, "ruby-orbit-activities/#{OrbitActivities::VERSION}")
            @body = params.fetch(:body, nil)
            @filters = params.fetch(:filters, nil)
            @member_id = params.fetch(:member_id, nil)
            @activity_id = params.fetch(:activity_id, nil)

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
            else
                raise ArgumentError, "Activity type is unrecognized. Must be one of: new_activity, list_activities, get_activity, list_member_activities, create_post, delete_post, update_activity"
            end
        end

        def new_activity
            OrbitActivities::HTTP.post(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities",
                user_agent: @user_agent,
                api_key: @api_key,
                body: @body
            )
        end

        def list_activities
            OrbitActivities::HTTP.get(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities/",
                user_agent: @user_agent,
                api_key: @api_key,
                filters: @filters
            )
        end

        def get_activity
            OrbitActivities::HTTP.get(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/activities/#{@activity_id}",
                user_agent: @user_agent,
                api_key: @api_key
            )            
        end

        def list_member_activities
            OrbitActivities::HTTP.get(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities",
                user_agent: @user_agent,
                api_key: @api_key,
                filters: @filters
            )           
        end

        def create_post
            OrbitActivities::HTTP.post(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities",
                user_agent: @user_agent,
                api_key: @api_key,
                body: @body
            )            
        end

        def delete_post
            OrbitActivities::HTTP.delete(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities/#{@activity_id}",
                user_agent: @user_agent,
                api_key: @api_key
            )   
        end

        def update_activity
            OrbitActivities::HTTP.put(
                url: "https://app.orbit.love/api/v1/#{@workspace_id}/members/#{@member_id}/activities/#{@activity_id}",
                user_agent: @user_agent,
                api_key: @api_key,
                body: @body
            )    
        end
    end
end