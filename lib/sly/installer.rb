require 'sly'

class Sly::Installer

  def self.process(username, password)
    connector = Sly::Connector.new({email: username, api_key: password})
    results = connector.authenticate!

    if success_call?(results)
      create_file(username, password)
      p "Thanks! Your details are currently stored in ~/.slyrc to authorise your interactions using the Sprint.ly CLI"
    else
      raise "The details provided were incorrect, please check your details and try again."
    end
  end

  def self.validate_install!
    unless File.exist?(ENV["HOME"]+"/.slyrc")
      raise "You have not setup Sly on your machine yet, please run the sly install command first."
    end
  end

  private

  def self.create_file(username, password)
    file = File.open(ENV["HOME"]+"/.slyrc", "w") { |file| file.puts(username+":"+password) }
  end

  def self.success_call?(input)
    return true if input.class == Array
  end

end
