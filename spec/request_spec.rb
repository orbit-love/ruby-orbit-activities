require "spec_helper"

RSpec.describe OrbitActivities::Request do
    let(:subject) do
        OrbitActivities::Request.new(
            api_key: "12345",
            workspace_id: "1234",
            user_agent: "community-ruby-starfleet-orbit/1.0",
            body: {
                activity: {
                    activity_type: "starfleet:signup",
                    tags: ["channel:twitter"],
                    title: "New Planet Signed Up for Starfleet",
                    description: "Klingon has joined Starfleet via Twitter",
                    occurred_at: "2021-03-09",
                    member: {
                        name: "Worf"
                    }
                },
                identity: {
                    source: "klingon_registry",
                    username: "worf"
                }
            }.to_json
        )
    end

    describe "subject" do
        before(:each) do
            stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
            .with(
              headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' },
              body: "{\"activity\":{\"activity_type\":\"starfleet:signup\",\"tags\":[\"channel:twitter\"],\"title\":\"New Planet Signed Up for Starfleet\",\"description\":\"Klingon has joined Starfleet via Twitter\",\"occurred_at\":\"2021-03-09\",\"member\":{\"name\":\"Worf\"}},\"identity\":{\"source\":\"klingon_registry\",\"username\":\"worf\"}}"
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

        it "includes the custom user agent" do
            expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
        end
    end
    
    describe "#call" do
        it "returns a HTTP 200 status for a successful request" do
            stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
            .with(
              headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' },
              body: "{\"activity\":{\"activity_type\":\"starfleet:signup\",\"tags\":[\"channel:twitter\"],\"title\":\"New Planet Signed Up for Starfleet\",\"description\":\"Klingon has joined Starfleet via Twitter\",\"occurred_at\":\"2021-03-09\",\"member\":{\"name\":\"Worf\"}},\"identity\":{\"source\":\"klingon_registry\",\"username\":\"worf\"}}"
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

            response = subject.call

            expect(response["response"]["code"]).to eq("SUCCESS")
        end

        it "raises an exception if the API response cannot be parsed" do
            stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
            .with(
              headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' },
              body: "{\"activity\":{\"activity_type\":\"starfleet:signup\",\"tags\":[\"channel:twitter\"],\"title\":\"New Planet Signed Up for Starfleet\",\"description\":\"Klingon has joined Starfleet via Twitter\",\"occurred_at\":\"2021-03-09\",\"member\":{\"name\":\"Worf\"}},\"identity\":{\"source\":\"klingon_registry\",\"username\":\"worf\"}}"
            )
            .to_return(
                status: 500,
                headers: {}
            )

            expect { subject.call }.to raise_error(ArgumentError, "Expected confirmation from the Orbit API, but received nothing. Please check your logs and try again.")
        end
    end
end