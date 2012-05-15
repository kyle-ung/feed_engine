require 'spec_helper'

describe 'api/v1/feed', type: :api do
  let!(:user) { FactoryGirl.create(:user_with_growls) }
  let!(:token) { user.authentication_token }
  let!(:other_user) { FactoryGirl.create(:user_with_growls) }

  context "growls viewable by this user" do
    let(:url) { "http://api.hungrlr.awesome/v1/feeds/#{user.display_name}" }
      get "#{url}.json"
    end
    describe "json" do
      it "returns a successful response" do
        last_response.status.should == 200
      end
      it "returns the specified users last 3 growls" do
        JSON.parse(last_response.body)["items"]["most_recent"].size == user.growls.size
      end
    end
  end

  context "creating growls through the api" do
    let(:message) { FactoryGirl.build(:message) }
    let(:url) { "http://api.hungrlr.dev/v1/feeds/#{user.display_name}" }
    before(:each) do
    end

    describe "when valid parameters are passed in" do
      it "returns a successful response" do
        post "#{url}.json", token: user.authentication_token, body: { type: "Message", comment: message.comment }
        last_response.status.should == 201
      end
    end

    describe "when invalid parameters are passed in" do
      it "returns a unsuccessful response" do
        post "#{url}.json", token: user.authentication_token, body: { type: "Message" }
        last_response.status.should == 406
        last_response.body.should =~ /"You must provide a message."/
      end
    end
  end
end
