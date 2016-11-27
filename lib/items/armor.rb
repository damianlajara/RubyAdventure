require_relative 'item'

class Armor < Item
  attr_reader :defense
  attr_accessor :equipped
  def initialize(name, item_args = {})
    super(name, item_args)
    @equipped = false
    @defense = item_args[:defense] || 0
  end
end
