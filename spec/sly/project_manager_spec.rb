require 'spec_helper'

describe Sly::ProjectManager do

  SLY_LOCATION =  "/tmp/.sly"

  before :each do
    setup_complete_home_directory
    @manager = Sly::ProjectManager.new
  end

  after :each do
    rm_rf SLY_LOCATION if File.exists?(SLY_LOCATION)
  end

  describe :available_projects do
    it "returns an array of Sprint.ly projects" do
      @manager.available_projects.first.class.should == Sly::Project
    end
  end

  describe :project_listings do
    it "returns a formatted string listing each project" do
      @manager.project_listings.should include "#{ENV["sprintly_product_id"]} - #{ENV["sprintly_product_name"]}"
    end
  end

  describe :setup_project do
    context "incorrect id" do
      it "raises an exception" do
        random_int = 4 # chosen by fair dice roll. guaranteed to be random.
        expect { @manager.setup_project("/tmp", random_int) }.to raise_exception "That ID does not match any of the projects available; please try again:"
      end
    end

    context "correct id" do
      it "creates a .sly file in the project folder" do
        @manager.setup_project("/tmp", ENV["sprintly_product_id"])
        File.exists?(SLY_LOCATION).should be_true
      end

      it "writes the project id to the .sly file" do
        @manager.setup_project("/tmp", ENV["sprintly_product_id"])
        File.read(SLY_LOCATION).should include "id: #{ENV["sprintly_product_id"]}"
      end
    end
  end

end
