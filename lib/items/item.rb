# TODO -> Add a description to every Item
class Item
  attr_reader :name, :price, :sell_value, :description
  def initialize(name = "", item_args={})
    @name = name
    @price = item_args[:price] || 0
    @sell_value = item_args[:sell_value] || 0
    @description = item_args[:description] || ""
  end

  def to_s
    @name
  end
end
