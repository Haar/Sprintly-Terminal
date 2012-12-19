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

end
