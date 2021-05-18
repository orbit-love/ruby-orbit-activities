# frozen_string_literal: true

require "net/http"
require "json"
require_relative "utils"

module OrbitActivities
    class Request
        attr_reader :api_key, :workspace_id, :user_agent, :body

        def initialize(params = {})
            @api_key = params.fetch(:api_key)
            @workspace_id = params.fetch(:workspace_id)
            @user_agent = params.fetch(:user_agent, "ruby-orbit-activities/#{OrbitActivities::VERSION}")
            @body = params.fetch(:body)

            after_initialize!
        end

        def after_initialize!
            call
        end

        def call
            payload = make_request
            validate_payload(payload)
        end

        def make_request
            url = URI("https://app.orbit.love/api/v1/#{@workspace_id}/activities")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            req = Net::HTTP::Post.new(url)
            req["Accept"] = "application/json"
            req["Content-Type"] = "application/json"
            req["Authorization"] = "Bearer #{@api_key}"
            req["User-Agent"] = @user_agent

            req.body = @body

            response = http.request(req)

            response.body
        end

        def validate_payload(payload)
            JSON.parse(payload) if OrbitActivities::Utils.valid_json?(payload)
        end
    end
end