require 'spec_helper'

describe Sly::GUI do

  describe :display_dashboard do
    context "no items" do
      it "displays an empty table" do
        @project = Sly::Project.new({"archived" => false,
                                     "name"     => ENV["sprintly_product_name"],
                                     "admin"    => true,
                                     "id"       => ENV["sprintly_product_id"].to_i})
        Sly::GUI.display_dashboard(@project)
      end
    end


    context "with items" do
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

      describe "display_dashboard" do
        it "displays the current state of the dashboard" do
          Sly::GUI.display_dashboard(@project)
        end
      end

      describe "display_backlog" do
        it "displays the current project's backlog items" do
          STDOUT.should_receive(:print).with("  ---------------- Backlog ----------------  \n")
          STDOUT.should_receive(:print).with(@project.backlog.first.overview)
          STDOUT.should_receive(:print).with("\n")
          Sly::GUI.display_backlog(@project)
        end
      end

      describe "display_backlog" do
        it "displays the current project's in-progress items" do
          STDOUT.should_receive(:print).with("  ---------------- Current ----------------  \n")
          STDOUT.should_receive(:print).with(@project.current.first.overview)
          STDOUT.should_receive(:print).with("\n")
          Sly::GUI.display_current(@project)
        end
      end

      describe "display_backlog" do
        it "displays the current project's completed items" do
          STDOUT.should_receive(:print).with("  ---------------- Completed ----------------  \n")
          STDOUT.should_receive(:print).with(@project.complete.first.overview)
          STDOUT.should_receive(:print).with("\n")
          Sly::GUI.display_complete(@project)
        end
      end
    end
  end
end
