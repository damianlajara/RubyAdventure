# TODO: Add a description to every Item
# TODO: Add a level to the items. Based on the amount of damage, defense, etc it levels up the item.
# The higher the level, the better it is. This way you can always carry mutiple copies of the same weapons,
# but still be able to equip the best one. Comes in handy for treasures. Can give you different weapons based on the rarity.
#
class Item
  attr_reader :name, :price, :sell_value, :description
  def initialize(name = '', item_args = {})
    @name = name
    @price = item_args[:price] || 0
    @sell_value = item_args[:sell_value] || 0
    @description = item_args[:description] || ''
  end

  def to_s
    @name
  end
end
