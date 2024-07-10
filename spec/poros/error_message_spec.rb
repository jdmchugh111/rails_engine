require "rails_helper"

RSpec.describe ErrorMessage do
  it "exists" do
    message = "This is an error"
    status_code = "400"

    error = ErrorMessage.new(message, status_code)

    expect(error).to be_a ErrorMessage
    expect(error.message).to eq("This is an error")
    expect(error.status_code).to eq("400")
  end
end