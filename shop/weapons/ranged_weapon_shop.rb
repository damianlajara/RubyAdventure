require_relative "../../helpers/attributes"
require_relative "../shop"

class RangedWeaponShop < Shop
  include Attributes::Weapon::Ranged
  attr_reader :weapons
  def initialize
    @weapons = []
    if $debug then puts "initializing ranged weapons" end
    #@@archer_weapon_names = %w[Arondight Gugnir Susano' Longinus Hrunting Clarent Shinigami Caliburn]
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    RANGED_WEAPON_NAMES.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @weapons.push(Weapon.new(name, { damage: effect }, price: price, sell_value: sell_value))
    end
  end

  def weapon_count
    RANGED_WEAPON_NAMES.length
  end

  def display_weapons
    @weapons.each_with_index(&Procs::DISPLAY)
  end

end
