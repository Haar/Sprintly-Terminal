class Sly::GUI
  def self.get_project_id(manager)
    project_id = gets
    begin
      manager.setup_project(Dir.pwd, project_id)
    rescue Exception => e
      $stderr.write e.to_s+"\n"
      get_project_id(manager)
    end
  end
end
