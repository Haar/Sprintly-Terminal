class Sly::Project

  attr_accessor :id, :name, :archived, :admin

  def initialize(project_attributes = {})
    @id = project_attributes["id"]
    @name = project_attributes["name"]
    @archived = project_attributes["archived"]
    @admin = project_attributes["admin"]
  end

  def save!
    # Reserved for updating the API
  end

  def to_s
    return "#{@id} - #{@name}"
  end

end
