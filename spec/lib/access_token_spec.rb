require 'rails_helper'

RSpec.describe "AccessToken" do
  it "retruns valid GOOGLE_ACCESS_TOKEN" do
    token = AccessToken.instance.to_s
    expect(token.size).to eq ENV["GOOGLE_ACCESS_TOKEN_LENGTH"].to_i
  end
end