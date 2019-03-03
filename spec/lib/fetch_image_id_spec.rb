require 'rails_helper'

RSpec.describe "FetchImageID" do
  it "fetches image IDs" do
    expect(FetchImageID.call.size).to be > 0
  end

  it "fetches mediaItems json" do
    results = FetchImageID.send(:fetch)
    expect(results).to have_key("mediaItems")
  end
end