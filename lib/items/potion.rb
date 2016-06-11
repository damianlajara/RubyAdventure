# item1 = Potion.new("Item 2 (Potion)", { health: 100 }, price: 100, sell_value: 50)
# p item1
require_relative "item"
class Potion < Item
  attr_reader :health
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @health = specialty[:health] || 0
  end
end
