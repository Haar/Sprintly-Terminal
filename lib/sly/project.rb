require 'sly'
require "yaml"
require 'fileutils'

class Sly::Project
  include FileUtils

  attr_accessor :id, :name, :archived, :admin, :items

  def initialize(project_attributes = {})
    @id = project_attributes["id"]
    @name = project_attributes["name"]
    @archived = project_attributes["archived"]
    @admin = project_attributes["admin"]
    @items = []
  end

  def save!
    # Reserved for updating the API
  end

  def to_s
    return "#{@id} - #{@name}"
  end

  def self.load(file)
    begin
      YAML::load(File.open(file))
    rescue Exception => e
      raise "Unable to locate project file #{file}"
    end
  end

  def update
    download_child_items
    save_child_items
  end

  def backlog
    @items.select { |item| item.status == "backlog" }
  end

  def current
    @items.select { |item| item.status == "in-progress" }
  end

  def complete
    @items.select { |item| item.status == "complete" }
  end

  private

  def download_child_items
    items = Sly::Connector.connect_with_defaults.items_for_product(@id)
    items.each { |item| @items << Sly::Item.new(item) }
  end

  def save_child_items
    target_file = File.join(pwd, '.sly', 'items')
    File.open(target_file, 'w') { |file| file.write @items.to_yaml }
  end

end
