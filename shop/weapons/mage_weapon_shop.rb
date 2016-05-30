require_relative "../../helpers/attributes"
require_relative "../shop"

class MageWeaponShop < Shop
  include Attributes::Weapon::Mage
  attr_reader :weapons
  def initialize
    @weapons = []
    if $debug then puts "initializing mage weapons" end
    #@@mage_weapon_names = %w[Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist]
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    #use each with index
    MAGE_WEAPON_NAMES.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @weapons.push(Weapon.new(name, { damage: effect }, price: price, sell_value: sell_value))
    end
  end

  def weapon_count
    MAGE_WEAPON_NAMES.length
  end

  def display_weapons
    @weapons.each_with_index(&Procs::DISPLAY)
  end

end
