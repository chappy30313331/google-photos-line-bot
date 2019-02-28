require 'rails_helper'

RSpec.describe "FetchImageID" do
  it "fetches all image IDs" do
    expect{FetchImageID.call}.to change(ImageMessage, :count)
  end

  it "fetches image IDs" do
    results = FetchImageID.send(:fetch)
    expect(results).to have_key("mediaItems")
  end
end