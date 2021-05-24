require "spec_helper"

RSpec.describe OrbitActivities::Request do
    describe "new request" do
        context "for a new activity" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "new_activity",
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

            it "returns a HTTP 200 status for a successful request" do
                response = subject.new_activity
    
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
    
                expect { subject.new_activity }.to raise_error(ArgumentError, "Expected confirmation from the Orbit API, but received nothing. Please check your logs and try again.")
            end
        end

        context "for listing activities with filters" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "list_activities",
                    filters: {
                        orbit_level: 1
                    }
                )
            end

            before(:each) do
                stub_request(:get, "https://app.orbit.love/api/v1/1234/activities?orbit_level=1")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Accept' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' }
                )
                .to_return(
                    status: 200,
                    body: {
                        data: [
                            {
                                id: "6",
                                type: "spec_activity",
                                attributes: {
                                    action: "spec_action",
                                    created_at: "2021-04-01T16:03:02.052Z",
                                    key: "spec_activity_key#1",
                                    occurred_at: "2021-04-01T16:03:02.050Z",
                                    type: "SpecActivity",
                                    tags: "[\"spec-tag-1\"]",
                                    orbit_url: "https://localhost:3000/test/activities/6",
                                    weight: "1.0"
                                },
                                relationships: {
                                    activity_type: {
                                        data: {
                                            id: "20",
                                            type: "activity_type"
                                        }
                                    }
                                },
                                member: {
                                    data: {
                                        id: "3",
                                        type: "member"
                                    }
                                }
                            }
                        ]
                    }.to_json.to_s,
                    headers: {}
                )
            end

            it "includes the custom user agent" do
                expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
            end

            it "returns a successful response for a successful request" do
                response = subject.list_activities
    
                expect(response["data"]).to be_truthy
            end
        end

        context "for listing activities without filters" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "list_activities"
                )
            end

            before(:each) do
                stub_request(:get, "https://app.orbit.love/api/v1/1234/activities")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Accept' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' }
                )
                .to_return(
                    status: 200,
                    body: {
                        data: [
                            {
                                id: "6",
                                type: "spec_activity",
                                attributes: {
                                    action: "spec_action",
                                    created_at: "2021-04-01T16:03:02.052Z",
                                    key: "spec_activity_key#1",
                                    occurred_at: "2021-04-01T16:03:02.050Z",
                                    type: "SpecActivity",
                                    tags: "[\"spec-tag-1\"]",
                                    orbit_url: "https://localhost:3000/test/activities/6",
                                    weight: "1.0"
                                },
                                relationships: {
                                    activity_type: {
                                        data: {
                                            id: "20",
                                            type: "activity_type"
                                        }
                                    }
                                },
                                member: {
                                    data: {
                                        id: "3",
                                        type: "member"
                                    }
                                }
                            }
                        ]
                    }.to_json.to_s,
                    headers: {}
                )
            end

            it "includes the custom user agent" do
                expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
            end

            it "returns a successful response for a successful request" do
                response = subject.list_activities
    
                expect(response["data"]).to be_truthy
            end
        end

        context "for fetching a single activity" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "get_activity",
                    activity_id: "123"
                )
            end

            before(:each) do
                stub_request(:get, "https://app.orbit.love/api/v1/1234/activities/123")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Accept' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' }
                )
                .to_return(
                    status: 200,
                    body: {
                        data: [
                            {
                                id: "6",
                                type: "spec_activity",
                                attributes: {
                                    action: "spec_action",
                                    created_at: "2021-04-01T16:03:02.052Z",
                                    key: "spec_activity_key#1",
                                    occurred_at: "2021-04-01T16:03:02.050Z",
                                    type: "SpecActivity",
                                    tags: "[\"spec-tag-1\"]",
                                    orbit_url: "https://localhost:3000/test/activities/6",
                                    weight: "1.0"
                                },
                                relationships: {
                                    activity_type: {
                                        data: {
                                            id: "20",
                                            type: "activity_type"
                                        }
                                    }
                                },
                                member: {
                                    data: {
                                        id: "3",
                                        type: "member"
                                    }
                                }
                            }
                        ]
                    }.to_json.to_s,
                    headers: {}
                )
            end

            it "includes the custom user agent" do
                expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
            end

            it "returns a successful response for a successful request" do
                response = subject.get_activity
    
                expect(response["data"]).to be_truthy
            end
        end

        context "for fetching member activities with filters" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "list_member_activities",
                    member_id: "123",
                    filters: {
                        orbit_level: 1
                    }
                )
            end

            before(:each) do
                stub_request(:get, "https://app.orbit.love/api/v1/1234/members/123/activities?orbit_level=1")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Accept' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' }
                )
                .to_return(
                    status: 200,
                    body: {
                        data: [
                            {
                                id: "6",
                                type: "spec_activity",
                                attributes: {
                                    action: "spec_action",
                                    created_at: "2021-04-01T16:03:02.052Z",
                                    key: "spec_activity_key#1",
                                    occurred_at: "2021-04-01T16:03:02.050Z",
                                    type: "SpecActivity",
                                    tags: "[\"spec-tag-1\"]",
                                    orbit_url: "https://localhost:3000/test/activities/6",
                                    weight: "1.0"
                                },
                                relationships: {
                                    activity_type: {
                                        data: {
                                            id: "20",
                                            type: "activity_type"
                                        }
                                    }
                                },
                                member: {
                                    data: {
                                        id: "3",
                                        type: "member"
                                    }
                                }
                            }
                        ]
                    }.to_json.to_s,
                    headers: {}
                )
            end

            it "includes the custom user agent" do
                expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
            end

            it "returns a successful response for a successful request" do
                response = subject.list_member_activities
    
                expect(response["data"]).to be_truthy
            end
        end

        context "for fetching member activities without filters" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "list_member_activities",
                    member_id: "123"
                )
            end

            before(:each) do
                stub_request(:get, "https://app.orbit.love/api/v1/1234/members/123/activities")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Accept' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' }
                )
                .to_return(
                    status: 200,
                    body: {
                        data: [
                            {
                                id: "6",
                                type: "spec_activity",
                                attributes: {
                                    action: "spec_action",
                                    created_at: "2021-04-01T16:03:02.052Z",
                                    key: "spec_activity_key#1",
                                    occurred_at: "2021-04-01T16:03:02.050Z",
                                    type: "SpecActivity",
                                    tags: "[\"spec-tag-1\"]",
                                    orbit_url: "https://localhost:3000/test/activities/6",
                                    weight: "1.0"
                                },
                                relationships: {
                                    activity_type: {
                                        data: {
                                            id: "20",
                                            type: "activity_type"
                                        }
                                    }
                                },
                                member: {
                                    data: {
                                        id: "3",
                                        type: "member"
                                    }
                                }
                            }
                        ]
                    }.to_json.to_s,
                    headers: {}
                )
            end

            it "includes the custom user agent" do
                expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
            end

            it "returns a successful response for a successful request" do
                response = subject.list_member_activities
    
                expect(response["data"]).to be_truthy
            end
        end

        context "for a new post activity" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "create_post",
                    member_id: "123",
                    body: {
                        activity: {
                            activity_type: "starfleet:signup",
                            tags: ["channel:twitter"],
                            title: "New Planet Signed Up for Starfleet",
                            description: "Klingon has joined Starfleet via Twitter",
                            occurred_at: "2021-03-09",
                            type: "post",
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

            before(:each) do
                stub_request(:post, "https://app.orbit.love/api/v1/1234/members/123/activities")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' },
                body: "{\"activity\":{\"activity_type\":\"starfleet:signup\",\"tags\":[\"channel:twitter\"],\"title\":\"New Planet Signed Up for Starfleet\",\"description\":\"Klingon has joined Starfleet via Twitter\",\"occurred_at\":\"2021-03-09\",\"type\":\"post\",\"member\":{\"name\":\"Worf\"}},\"identity\":{\"source\":\"klingon_registry\",\"username\":\"worf\"}}"
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

            it "returns a HTTP 200 status for a successful create post request" do
                response = subject.create_post
    
                expect(response["response"]["code"]).to eq("SUCCESS")
            end
    
            it "raises an exception if the API response cannot be parsed" do
                stub_request(:post, "https://app.orbit.love/api/v1/1234/members/123/activities")
                .with(
                  headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' },
                  body: "{\"activity\":{\"activity_type\":\"starfleet:signup\",\"tags\":[\"channel:twitter\"],\"title\":\"New Planet Signed Up for Starfleet\",\"description\":\"Klingon has joined Starfleet via Twitter\",\"occurred_at\":\"2021-03-09\",\"type\":\"post\",\"member\":{\"name\":\"Worf\"}},\"identity\":{\"source\":\"klingon_registry\",\"username\":\"worf\"}}"
                )
                .to_return(
                    status: 500,
                    headers: {}
                )
    
                expect { subject.create_post }.to raise_error(ArgumentError, "Expected confirmation from the Orbit API, but received nothing. Please check your logs and try again.")
            end
        end

        context "for deleting a post activity" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "delete_post",
                    member_id: "123",
                    activity_id: "1234"
                )
            end

            before(:each) do
                stub_request(:delete, "https://app.orbit.love/api/v1/1234/members/123/activities/1234")
                .with(
                headers: { 'Authorization' => "Bearer 12345", 'Accept' => '*/*', 'User-Agent'=>'community-ruby-starfleet-orbit/1.0' }
                )
                .to_return(
                    status: 204,
                    body: "",
                    headers: {}
                )
            end

            it "includes the custom user agent" do
                expect(subject.user_agent).to eq("community-ruby-starfleet-orbit/1.0")
            end

            it "returns a successful response for a successful request" do
                response = subject.delete_post

                expect(response).to eq("Deletion successful")
            end
        end

        context "for updating an activity" do
            let(:subject) do
                OrbitActivities::Request.new(
                    api_key: "12345",
                    workspace_id: "1234",
                    user_agent: "community-ruby-starfleet-orbit/1.0",
                    action: "update_activity",
                    member_id: "123",
                    activity_id: "123456",
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

            before(:each) do
                stub_request(:put, "https://app.orbit.love/api/v1/1234/members/123/activities/123456")
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

            it "returns a HTTP 200 status for a successful request" do
                response = subject.update_activity
    
                expect(response).to eq("Update successful")
            end
        end
    end
end