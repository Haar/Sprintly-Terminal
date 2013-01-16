class Sly::Item

  attr_accessor :number, :archived, :title, :score, :tags, :status

  def initialize(item_attributes = {})
    @number   = item_attributes["number"]
    @archived = item_attributes["archived"]
    @title    = item_attributes["title"]
    @score    = item_attributes["score"]
    @tags     = item_attributes["tags"]
    @status   = item_attributes["status"]
  end

  def overview
    self.prettify([@title, @number].join("\n#"), 40)
  end

  alias_method :to_s, :overview

  def print
    STDOUT.print self.overview
  end

  def prettify(content, wrap_limit)
    content.scan(/\S.{0,#{wrap_limit}}\S(?=\s|$)|\S+/).join("\n")
  end

end
