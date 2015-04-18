class Item
  attr_reader :name, :price, :sell_value, :description
  def initialize(name, price, sell_value)
    @name = name
    @price = price
    @sell_value = sell_value
  end

  def to_s
    @name
  end
end
