require 'sly'
require "yaml"
require 'fileutils'
require 'rainbow'

class Sly::Project
  include FileUtils

  attr_accessor :id, :name, :archived, :admin, :items

  def initialize(project_attributes = {})
    @id = project_attributes["id"]
    @name = project_attributes["name"]
    @archived = project_attributes["archived"]
    @admin = project_attributes["admin"]
    @items = {
      'backlog' => [], 'in-progress' => [], 'completed' => [], 'accepted' => []
    }
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

  def update(status = nil)
    load_state rescue nil
    begin
      download_child_items(status)
      save_state
    rescue Exception => e
      puts e.message
      puts e.backtrace
      puts " Failed to connect to the Sprint.ly service, using last known values. ".colour(:white).background(:red)
      load_state
    end
  end

  def backlog
    @items['backlog']
  end

  def current
    @items['in-progress']
  end

  def complete
    @items['completed']
  end

  private

  def download_child_items(status)
    items = Sly::Connector.connect_with_defaults.items_for_product(@id, status)

    clear_existing_items(status)

    items.each do |item|
      @items[item['status']] << Sly::Item.new(item)
    end
  end

  def save_state
    target_file = File.join(pwd, '.sly', 'items')
    File.open(target_file, 'w') { |file| file.write @items.to_yaml }
  end

  def load_state
    target_file = File.join(pwd, '.sly', 'items')
    @items = YAML::load(File.open(target_file))
  end

  def clear_existing_items(status)
    if status.nil?
      @items.keys.each { |key| @items[key] = [] }
    else
      @items[status] = []
    end
  end

end
