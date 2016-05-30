#item3 = Armor.new("Item 4 (Armor)", { defense: 200 }, price: 200, sell_value: 100)
#p item3
require_relative "item"
class Armor < Item
  attr_reader :defense
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @defense = specialty[:defense] || 0
  end
end
