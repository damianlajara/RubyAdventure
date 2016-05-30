require_relative "../../helpers/attributes"
require_relative "../shop"

class MageArmorShop < Shop
  include Attributes::Armor::Mage
  attr_reader :armor
  def initialize
    @armor = []
    #MAGE_WEAPON_NAMES = %w(Colossus Eternal_Vanguard Prism Valkyrie Trident Eclipse Lunar_Spirit Astral_Inducer)
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    MAGE_WEAPON_NAMES.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @armor.push(Armor.new(name, { defense: effect }, price: price, sell_value: sell_value))
    end
  end

  def armor_count
    MAGE_WEAPON_NAMES.length
  end

  def display_armor
    @armor.each_with_index(&Procs::DISPLAY)
  end

end
