require_relative "../../helpers/attributes"
require_relative "../shop"

class SoldierWeaponShop < Shop
  include Attributes::Weapon::Soldier
  attr_reader :weapons
  def initialize
    @weapons = []
    if $debug then puts "initializing soldier weapons" end
    #@@soldier_weapon_names = %w[Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur]
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    SOLDIER_WEAPON_NAMES.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @weapons.push(Weapon.new(name, { damage: effect }, price: price, sell_value: sell_value))
    end
  end

  def weapon_count
    SOLDIER_WEAPON_NAMES.length
  end

  def display_weapons
    @weapons.each_with_index(&Procs::DISPLAY)
  end

end
