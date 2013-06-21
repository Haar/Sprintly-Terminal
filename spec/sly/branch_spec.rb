require 'spec_helper'
include FileUtils

describe Sly::Branch do

  TEST_FOLDER = "branching_specs"

  before do
    mkdir_p TEST_FOLDER unless File.exists? TEST_FOLDER
    cd TEST_FOLDER
    Sly::Branch.git :init
    touch 'foo'
    Sly::Branch.git :add, '.'
    Sly::Branch.git :commit, '-m Foo'
  end

  after do
    cd ".."
    rm_rf TEST_FOLDER if File.exists? TEST_FOLDER
  end

  describe :for do
    it "raises an exception if there is no sly project setup" do
      expect { Sly::Branch.for("1") }.to raise_error "Unable to locate project files"
    end

    it "raises an exception if there is no item found by that number" do
      mkdir ".sly"
      touch File.join(".sly", "items")
      expect { Sly::Branch.for("1") }.to raise_error "No Sprint.ly item found with that number"
    end

    context "item exists with that number" do
      before do
        Sly::Item.stub(with_number: Sly::Item.new("number" => "500", "type"   => "story",
                                                  "status" => "in-progress", "score"  => "M",
                                                  "title"  => "Magical wonderful story")
                                                 )
      end

      context "branch does not exist" do
        it "creates the git branch" do
          Sly::Branch.for("500")
          Sly::Branch.git(:branch).should =~ /500\n/
        end
      end

      it "switches to the branch" do
          Sly::Branch.for("500")
          Sly::Branch.git(:branch).should =~ /\* feature\/.+-500\n/
      end

      context "branch already exists" do
        before do
          Sly::Branch.git :checkout, '-b feature/magical-wonderful-story-500'
        end

        it "does not attempt to recreate the git branch" do
          Sly::Branch.should_not_receive(:git).with(:branch, '-b feature/magical-wonderful-story-500')
          Sly::Branch.for("500")
        end
      end
    end
  end
end
