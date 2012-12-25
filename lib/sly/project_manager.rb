require 'fileutils'
require 'yaml'

class Sly::ProjectManager
  include FileUtils

  attr_reader :available_projects
  attr :connector
  attr :projects_json

  def initialize
    @connector = Sly::Connector.connect_with_defaults
    @projects_json = @connector.products
    @available_projects = []
    @projects_json.each do |project_json|
      @available_projects << Sly::Project.new(project_json)
    end
  end

  def project_listings
    return @available_projects.map(&:to_s).join("\n")
  end

  def setup_project(directory, project_id)
    target_file = File.join(directory, ".sly")
    touch target_file
    selected_project = @available_projects.select { |project| project.id == project_id.to_i }.first
    if selected_project
      File.open(target_file, 'w') { |file| file.write selected_project.to_yaml }
      $stdout.write "Thanks! That's Sly all setup for the current project, run `sly help` to see the commands available.\n"
    else
      raise "That ID does not match any of the projects available; please try again:"
    end
  end

end
