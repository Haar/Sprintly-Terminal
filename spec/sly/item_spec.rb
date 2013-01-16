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

    it "prints the item to the STDOUT" do
      STDOUT.should_receive(:print)
      @item.print
    end
  end
end
