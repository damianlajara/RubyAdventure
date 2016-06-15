#item2 = Weapon.new("Item 3 (Weapon)", { damage: 150 }, price: 150, sell_value: 100)
#p item2
require_relative "item"
class Weapon < Item
  attr_reader :damage
  attr_accessor :equipped
  #include List_of_weapons
  #TODO make specialty a default or figure out a way to remove it or merge with item_args
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @equipped = false
    @damage = specialty[:damage] || 0
  end
end
