require 'sly'

describe Sly::Item do

  before :each do
    @item_hash = YAML::load(File.open("spec/fixtures/items.yml")).first
  end

  it "can be initialized with a hash" do
    Sly::Item.new(@item_hash)
  end

  context :initialization do
    before :each do
      @item = Sly::Item.new(@item_hash)
    end

    it "sets the item number" do
      @item.number.should == 204
    end

    it "sets the archived status" do
      @item.archived.should be_false
    end

    it "sets the title" do
      @item.title.should == "Add the ability to reply to comments via email."
    end

    it "sets the score" do
      @item.score.should == "M"
    end

    it "sets the tags" do
      @item.tags.should == ["scoring", "backlog"]
    end

    it "sets the status" do
      @item.status.should == "accepted"
    end

    it "sets the type" do
      @item.type.should == :task
    end

    it "sets the assigned to status" do
      @item.assigned_to.should == "Assigned to Joe Stump"
    end
  end

  describe :overview do
    before :each do
      @item = Sly::Item.new(@item_hash)
    end

    it "returns a string" do
      @item.overview.class.should == String
    end

    it "includes the item description" do
      @item.overview.should include @item.title.slice(0..39)
    end

    it "includes the item number preceeded by a #" do
      @item.overview.should include "##{@item.number}"
    end
  end

  describe :print do
    before :each do
      @item = Sly::Item.new(@item_hash)
    end

    it "prints the item to the FOO" do
      $stdout.should_receive(:print)
      @item.print
    end
  end

  describe :slug do
    before :each do
      @item = Sly::Item.new(@item_hash)
    end

    it "removes common connective words" do
      @item.slug.should_not include 'to'
    end

    it "strips whitespace from the title" do
      @item.slug.should_not include ' '
    end

    it "removes non-alphanumeric characters" do
      @item.slug.should_not include '.'
    end

    it "removes capitalized characters" do
      @item.title = "FOO"
      @item.slug.should_not =~ /[A-Z]/
    end

    it "replaces underscores with hyphens" do
      @item.title = "_"
      @item.slug.should =~ /-/
    end

    it 'replaces slashes with hyphens' do
      @item.title = "/"
      @item.slug.should =~ /-/
    end

    it 'replaces successive hyphens' do
      @item.title = "---"
      @item.slug.should == "-"
    end

    it "replaces & with ' and '" do
      @item.title = "&"
      @item.slug.should include "and"
    end
  end

  describe :git_slug do
    let(:item) { Sly::Item.new(@item_hash) }
    it "appends the item number" do
      item.git_slug.should =~ /-#{item.number}$/
    end

    it "prepends the story type" do
      item.git_slug.should =~ /^task\/*/
    end

    context 'when a feature item' do
      it 'uses the first two components of the description' do
        item.type = :feature
        item.title = 'As a user I want better branch names so that my pull-requests/descriptions are easier to understand.'
        item.git_slug.should == 'feature/as-a-user-i-want-better-branch-names-204'
      end
    end
  end
end
