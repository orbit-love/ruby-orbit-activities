require "spec_helper"
require_relative "../lib/orbit_activities/http"

RSpec.describe OrbitActivities::HTTP do
  describe "#post" do
    context "for a successful HTTP POST request" do
      before(:each) do
        http = double
        allow(Net::HTTP).to receive(:start).and_yield http
        allow(http).to receive(:request).with(an_instance_of(Net::HTTP::Post)).and_return(Net::HTTPCreated)
        stub_request(:post, "https://api.example.com/example-request")
        .with(
        headers: { 'Authorization' => "Bearer abc123", 'Content-Type' => 'application/json', "User-Agent"=>"community-ruby-starfleet-orbit/#{OrbitActivities::VERSION}" },
        body: "this is a sample request"
        )
        .to_return(
            status: 200,
            body: {
                response: {
                    code: 'SUCCESS'
                }
            }.to_json.to_s,
            headers: {}
        )
      end

      it "returns the API response message" do
        expect(
          OrbitActivities::HTTP.post(
            url: "https://api.example.com/example-request",
            user_agent: "community-ruby-starfleet-orbit/#{OrbitActivities::VERSION}",
            api_key: "abc123",
            body: "this is a sample request"
          )
        ).to eql("response" => {"code"=>"SUCCESS"})
      end
    end

    context "for a rate limited POST request" do
      before(:each) do
        http = double
        allow(Net::HTTP).to receive(:start).and_yield http
        allow(http).to receive(:request).with(an_instance_of(Net::HTTP::Post)).and_return(Net::HTTPTooManyRequests)
        stub_request(:post, "https://api.example.com/example-request")
        .with(
        headers: { 'Authorization' => "Bearer abc123", 'Content-Type' => 'application/json', "User-Agent"=>"community-ruby-starfleet-orbit/#{OrbitActivities::VERSION}" },
        body: "this is a sample request"
        )
        .to_return(
          {
            status: 429,
            body: {
                response: {
                    code: 'Throttled'
                }
            }.to_json.to_s,
            headers: {}
          },
          {
            status: 200,
            body: {
              response: {
                code: 'SUCCESS'
              }
            }.to_json.to_s,
            headers: {}
          }
        )
      end

      it "waits 60 seconds and tries again for a successful request" do
        expect(OrbitActivities::HTTP).to receive(:sleep).with(60)
        expect(
          OrbitActivities::HTTP.post(
            url: "https://api.example.com/example-request",
            user_agent: "community-ruby-starfleet-orbit/#{OrbitActivities::VERSION}",
            api_key: "abc123",
            body: "this is a sample request"
          )
        ).to eql("response" => {"code"=>"SUCCESS"})
      end
    end
  end
end