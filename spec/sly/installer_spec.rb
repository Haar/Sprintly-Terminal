require 'spec_helper'

describe Sly::Installer do
  describe :process do
    it "checks the details are valid" do
      connector_stub = stub(:connector)
      connector_stub.stub(:authenticate!).and_return([])
      Sly::Connector.stub(:new).and_return(connector_stub)
      Sly::Connector.should_receive(:new)
      connector_stub.should_receive(:authenticate!)
      Sly::Installer.process(ENV['sprintly_email'], ENV['sprintly_api_key'])
    end

    context :valid_details do
      it "creates the rc file" do
        Sly::Installer.process(ENV['sprintly_email'], ENV['sprintly_api_key'])
        File.exists?(ENV['HOME']+"/.slyrc").should be_true
      end
    end

    context :invalid_details do
      it "throws an exception" do
        expect { Sly::Installer.process("Random@email.com", "random_key") }.to raise_exception "The details provided were incorrect, please check your details and try again."
      end
    end
  end

  describe :validate_install! do
    it "throws an error if no ~/.slyrc file is found in the home directory" do
      setup_empty_home_directory
      expect { Sly::Installer.validate_install! }.to raise_exception "You have not setup Sly on your machine yet, please run the sly install command first."
    end

    it "runs silently if there is a ~/.slyrc file in the home directory" do
      setup_complete_home_directory
      expect { Sly::Installer.validate_install! }.to_not raise_exception "You have not setup Sly on your machine yet, please run the sly install command first."
    end
  end

end
