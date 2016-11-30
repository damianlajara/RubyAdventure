# TODO: Add a description to every Item
# TODO: Add a level to the items. Based on the amount of damage, defense, etc it levels up the item.
# The higher the level, the better it is. This way you can always carry mutiple copies of the same weapons,
# but still be able to equip the best one. Comes in handy for treasures. Can give you different weapons based on the rarity.

class Item
  attr_reader :name, :price, :sell_value, :description
  def initialize(name = '', item_args = {})
    # If for some reason we didnt pass in a name but we passed in item_args
    # then it will initialize name with item_args instead
    # Ex: Item.new(price: 500) => name.price == 500 && item_args == {}
    # To account for this edge case, roll over name into item_args

    # if name is a hash and has properties and item_args is empty, then we know for sure the above edge case occurred
    item_args = name if name.is_a?(Hash) && !name.empty? && item_args.empty?
    default_name = name.is_a?(String) ? name : ''

    @name = item_args[:name] || default_name
    @price = item_args[:price] || 0
    @sell_value = item_args[:sell_value] || 0
    @description = item_args[:description] || ''
  end

  def to_s
    @name
  end
end
