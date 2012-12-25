require 'spec_helper'

describe Sly::Project do

  it "can be initialised with a JSON hash of project details" do
    project = Sly::Project.new({"archived" => false,
                                "name"     => "Sprint.ly CLI",
                                "admin"    => true,
                                "id"       => 7515})
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
end
