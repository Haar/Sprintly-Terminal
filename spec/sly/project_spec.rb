require 'spec_helper'
load "sprintly_details.rb"

describe Sly::Project do

  it "can be initialised with a JSON hash of project details" do
    project = Sly::Project.new({"archived" => false,
                                "name"     => ENV["sprintly_product_name"],
                                "admin"    => true,
                                "id"       => ENV["sprintly_product_id"].to_i})
  end

  context "local attributes" do
    before :each do
      @project = Sly::Project.new({"archived" => false,
                                   "name"     => "Project Name",
                                   "admin"    => true,
                                   "id"       => 9999})
    end

    it "stores the id" do
      @project.id.should == 9999
    end

    it "stores the name" do
      @project.name.should == "Project Name"
    end

    it "stores the archived status" do
      @project.archived.should be_false
    end

    it "stores the admin status" do
      @project.admin.should be_true
    end
  end

  describe :initialize_from_file do
    context "file exists" do
      before :each do
        @project = Sly::Project.load("spec/fixtures/project.yml")
      end

      it "initializes an object from file" do
        @project.class.should == Sly::Project
      end

      it "keeps the basic details" do
        @project.name.should == "Sprint.ly"
      end
    end

    context "file does not exist" do
      it "raises a nice exception" do
        expect { @project = Sly::Project.load(".sly/random.yml") }.to raise_exception "Unable to locate project file .sly/random.yml"
      end
    end
  end

  context "child_items" do
    describe :update do
      before :each do
        @project = Sly::Project.new({"archived" => false,
                                     "name"     => ENV["sprintly_product_name"],
                                     "admin"    => true,
                                     "id"       => ENV["sprintly_product_id"].to_i})
        @stub_connector = stub(:connector)
        @stub_connector.stub(:items_for_product).with(@project.id, nil).and_return(YAML::load(File.open("spec/fixtures/items.yml")))
        Sly::Connector.stub(:connect_with_defaults).and_return(@stub_connector)
      end

      it "downloads new items" do
        @stub_connector.should_receive(:items_for_product).with(@project.id, nil)
        @project.update
      end

      it "generates new child objects for each JSON item" do
        Sly::Item.should_receive(:new).exactly(4).times
        @project.update
      end

      it "inserts the items to the projects items attribute" do
        @project.update
        @project.items.values.flatten.count.should == 4
      end

      it "write the child items to the .sly/items file" do
        mkdir_p ENV["HOME"]+"/.sly"
        File.stub(:join).and_return(ENV["HOME"]+"/.sly/items")
        @project.update
        File.exists?(ENV["HOME"]+"/.sly/items").should be_true
      end
    end

    context "item organisation" do
      before :each do
        @project = Sly::Project.new({"archived" => false,
                                     "name"     => ENV["sprintly_product_name"],
                                     "admin"    => true,
                                     "id"       => ENV["sprintly_product_id"].to_i})
        @stub_connector = stub(:connector)
        @stub_connector.stub(:items_for_product).with(@project.id, nil).and_return(YAML::load(File.open("spec/fixtures/items.yml")))
        Sly::Connector.stub(:connect_with_defaults).and_return(@stub_connector)
        @project.update
      end

      describe :backlog do
        it "returns all the items which have the status 'backlog'" do
          @project.backlog.first.title.should == "Add the ability to reply to comments via email."
        end
      end

      describe :current do
        it "returns all the items which have the status 'in-progress'" do
          @project.current.first.title.should == "Fake title number 2"
        end
      end

      describe :complete do
        it "returns all the items which have the status 'complete'" do
          @project.complete.first.title.should == "There's something about Mary"
        end
      end
    end
  end
end
