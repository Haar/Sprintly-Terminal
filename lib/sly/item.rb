require 'rainbow'

class Sly::Item

  TYPE_COLOR = { task: :black, test: :blue, defect: :red, story: :green }

  attr_accessor :number, :archived, :title, :score, :tags, :status, :type

  def initialize(item_attributes = {})
    @number   = item_attributes["number"]
    @archived = item_attributes["archived"]
    @title    = item_attributes["title"]
    @score    = item_attributes["score"]
    @tags     = item_attributes["tags"]
    @status   = item_attributes["status"]
    @type     = item_attributes["type"].to_sym
  end

  def overview
    quick_ref = "##{@number} - ".color(type_colour) + " #{@score} ".background(type_colour).color(:white)
    self.prettify([quick_ref, @title.color(type_colour)].join("\n"), 44)+"\n"
  end

  alias_method :to_s, :overview

  def print
    $stdout.print self.overview
  end

  def prettify(content, wrap_limit)
    content.scan(/\S.{0,#{wrap_limit}}\S(?=\s|$)|\S+/).join("\n")
  end

  private

  def type_colour
    TYPE_COLOR[@type]
  end

end
