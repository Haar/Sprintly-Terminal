require 'sly'
require 'fileutils'

include FileUtils

class Sly::Branch

  def self.for(item_number)
    item = Sly::Item.with_number(item_number)
    raise "No Sprint.ly item found with that number" if item.nil?
    current_branches = git :branch
    prefix = "-b" unless current_branches =~ /-#{item.number}\n/
    git :checkout, [prefix, item.git_slug].join(' ')
  end

  def self.git(command, arg = "")
    command = "git #{command.to_s} #{arg.to_s}"
    output = %x[#{command} 2>&1]
    raise "Error running #{command}" unless $?.success?
    output
  end

end
