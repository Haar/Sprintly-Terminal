require 'spec_helper'

describe Sly::GUI do

  before do
    @project = Sly::Project.new({"archived" => false,
                                 "name"     => ENV["sprintly_product_name"],
                                 "admin"    => true,
                                 "id"       => ENV["sprintly_product_id"].to_i})
    @stub_connector = stub(:connector)
    @stub_connector.stub(:items_for_product).with(@project.id).and_return(YAML::load(File.open("spec/fixtures/items.yml")))
    Sly::Connector.stub(:connect_with_defaults).and_return(@stub_connector)
    @project.update
  end

  describe "display_backlog" do
    it "displays the current project's backlog items" do
      $stdout.should_receive(:print).with("  ---------------- Backlog ----------------  \n")
      $stdout.should_receive(:print).with(@project.backlog.first.overview)
      $stdout.should_receive(:print).with("\n")
      Sly::GUI.display_backlog(@project)
    end
  end

  describe "display_current" do
    it "displays the current project's in-progress items" do
      $stdout.should_receive(:print).with("  ---------------- Current ----------------  \n")
      $stdout.should_receive(:print).with(@project.current.first.overview)
      $stdout.should_receive(:print).with("\n")
      Sly::GUI.display_current(@project)
    end
  end
end
