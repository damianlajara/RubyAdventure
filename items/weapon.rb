#item2 = Weapon.new("Item 3 (Weapon)", { damage: 150 }, price: 150, sell_value: 100)
#p item2
require_relative "item"
class Weapon < Item
  attr_reader :damage
  #include List_of_weapons
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @damage = specialty[:damage] || 0
  end
end
