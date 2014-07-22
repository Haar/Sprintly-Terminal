require 'spec_helper'

describe Sly::VersionChecker do

  describe "#run" do
    let!(:old_ruby_version) { RUBY_VERSION }
    after(:suite) { RUBY_VERSION = old_ruby_version }

    context "when running a version < 1.9.2" do
      it "raises an exception" do
        RUBY_VERSION = "1.8.7"
        expect { Sly::VersionChecker.run }.to raise_exception "Ruby versions less than 1.9.2 are not supported by Sly"
      end
    end

    context "when running a version >= 1.9.2" do
      it "does not raise an exception" do
        RUBY_VERSION = "1.9.2"
        expect { Sly::VersionChecker.run }.not_to raise_exception "Ruby versions less than 1.9.2 are not supported by Sly"
      end
    end
  end
end
