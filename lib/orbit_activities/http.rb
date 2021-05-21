# frozen_string_literal: true

require "net/http"
require "json"
require_relative "utils"

module OrbitActivities
    class HTTP
        def self.post(url:, user_agent:, api_key:, body:)
            url = URI(url)

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            req = Net::HTTP::Post.new(url)
            req["Accept"] = "application/json"
            req["Content-Type"] = "application/json"
            req["Authorization"] = "Bearer #{api_key}"
            req["User-Agent"] = user_agent

            req.body = body

            response = http.request(req)

            validate_payload(response.body)
        end

        def self.get(url:, user_agent:, api_key:, filters:)
            url = URI(url)
            url.query = URI.encode_www_form(filters) if filters

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            req = Net::HTTP::Get.new(url)
            req["Accept"] = "application/json"
            req["Authorization"] = "Bearer #{api_key}"

            response = http.request(req)

            validate_payload(response.body)
        end

        def self.delete(url:, user_agent:, api_key:)
            url = URI(url)

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            
            req = Net::HTTP::Delete.new(url)
            req["Authorization"] = "Bearer #{api_key}"

            response = http.request(req)

            "Deletion successful" if response.code = 204

            raise ArgumentError, response.message if response.code != 204 
        end

        def self.put(url:, user_agent:, api_key:, body:)
            url = URI(url)

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            req = Net::HTTP::Put.new(url)
            req["Accept"] = "application/json"
            req["Content-Type"] = "application/json"
            req["Authorization"] = "Bearer #{api_key}"
            req["User-Agent"] = user_agent

            req.body = body

            response = http.request(req)

            "Update successful" if response.code = 204

            raise ArgumentError, response.message if response.code != 204 
        end

        def self.validate_payload(payload)
            JSON.parse(payload) if OrbitActivities::Utils.valid_json?(payload)
        end
    end
end