require 'rails_helper'

RSpec.describe "Linebot", type: :request do
  describe "POST /callback" do
    before do
      @params = {
        destination: "xxxxxxxxxx", 
        events: [
          {
            replyToken: "replyToken",
            type: "message",
            timestamp: 1462629479859,
            source: {
              type: "user",
              userId: "U4af4980629..."
            },
            message: {
              id: "325708",
              type: "text",
              text: "キーワード"
            }
          }
        ]
      }
    end

    it "responds successfully" do
      post callback_path, params: @params, as: :json
      expect(response).to have_http_status(200)
    end
  end
end
