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

  def self.display_backlog(project)
    self.display_items("Backlog", project.backlog)
  end

  def self.display_current(project)
    self.display_items("Current", project.current)
  end

  private

  def self.display_items(title, items)
    STDOUT.print "  ---------------- #{title} ----------------  \n"
    items.map(&:print)
    STDOUT.print "\n"
  end
end
