require 'sprintly_connector'
load "sprintly_details.rb"

describe SprintlyConnector do

  describe :authentication do
    it "returns the request response as a hash" do
      sprintly = SprintlyConnector.new({email: "incorrect_user_email", api_key: "incorrect_key"})
      sprintly.authenticate!.should == {"message" => "Invalid or unknown user.", "code" => 403}
    end
  end

  describe :products do
    it "returns an array of the users products" do
      sprintly = SprintlyConnector.new({email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key']})
      sprintly.products.class.should == Array
    end

    it "returns an array of hashes representing each users product" do
      sprintly = SprintlyConnector.new({email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key']})
      sprintly.products.first.class.should == Hash
      sprintly.products.map(&:values).flatten.should include "Raptor"
    end
  end

end
