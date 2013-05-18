require 'fileutils'
require 'spec_helper'

include FileUtils

describe Sly::Connector, integration: true do
  describe :authentication do
    it "returns the request response as a hash" do
      sly = Sly::Connector.new({email: "incorrect_user_email", api_key: "incorrect_key"})
      sly.authenticate!.should == {"message" => "Invalid or unknown user.", "code" => 403}
    end
  end

  before(:all) do
    @sly = Sly::Connector.new({email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key']})
  end

  describe :products do
    it "returns an array of the users products" do
      @sly.products.class.should == Array
    end

    it "returns an array of hashes representing each users product" do
      @sly.products.first.class.should == Hash
      @sly.products.map(&:values).flatten.should include ENV["sprintly_product_name"]
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

  describe :connect_with_defaults do
    before :each do
      touch(File.join(ENV["HOME"], ".slyrc"))
    end
    context "having been installed" do
      it "loads the default file location" do

      end

      it "returns a copy of itself initialized with values loaded from the HOME directory" do
        Sly::Connector.should_receive(:new)
        Sly::Connector.connect_with_defaults
      end
    end

    context "not yet installed" do
      before :each do
        file_location = File.join(ENV["HOME"], ".slyrc")
        rm_rf(file_location) if File.exists?(file_location)
      end

      it "raises an exception" do
        expect { Sly::Connector.connect_with_defaults }.to raise_exception "Could not locate installation file at /tmp/fakehome/.slyrc"
      end
    end
  end
end
