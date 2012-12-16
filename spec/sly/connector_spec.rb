require 'sly'
load "sprintly_details.rb"

describe Sly::Connector, integration: true do
  before(:all) do
    @sly = Sly::Connector.new({email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key']})
  end

  describe :authentication do
    it "returns the request response as a hash" do
      sly = Sly::Connector.new({email: "incorrect_user_email", api_key: "incorrect_key"})
      sly.authenticate!.should == {"message" => "Invalid or unknown user.", "code" => 403}
    end
  end

  describe :products do
    it "returns an array of the users products" do
      @sly.products.class.should == Array
    end

    it "returns an array of hashes representing each users product" do
      @sly = Sly::Connector.new({email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key']})
      @sly.products.first.class.should == Hash
      @sly.products.map(&:values).flatten.should include "Raptor"
    end
  end

  describe :product_overview do
    before(:all) do
      @product = @sly.product_overview(ENV["sprintly_product_id"])
    end

    it "returns a hash representation of that product" do
      @product.class.should == Hash
    end

    it "returns the product details for the product by that ID" do
      @product.should include "name" => ENV["sprintly_product_name"]
    end
  end

  describe :items_for_product do
    before(:all) do
      @items = @sly.items_for_product(ENV["sprintly_product_id"])
    end

    it "returns an array of all tasks for that product" do
      @items.class.should == Array
    end

    it "returns a hash representation of each item" do
      @items.first.class.should == Hash
    end

    it "returns items for that product" do
      @items.first["product"].should == {"archived"=>0, "id"=>ENV["sprintly_product_id"].to_i, "name"=>ENV["sprintly_product_name"]}
    end
  end
end
