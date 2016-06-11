# TODO -> Add a description to every Item
# item = Item.new("Item 1 (Item)", { health: 100 }, price: 100, sell_value: 50)
# p item
class Item
  attr_reader :name, :price, :sell_value, :description
  def initialize(name = "", item_args) #item_args = {}
    @name = name
    @price = item_args[:price] || 0
    @sell_value = item_args[:sell_value] || 0
  end

  def to_s
    @name
  end
end
