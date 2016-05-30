require_relative "../../helpers/attributes"
require_relative "../shop"

class RangedArmorShop < Shop
  include Attributes::Armor::Ranged
  attr_reader :armor
  def initialize
    @armor = []
    #RANGED_WEAPON_NAMES = %w(Nightmare Ashura Ichimonji Lionheart Ascalon Nirvana Chaotic_Axis Ominous_Judgement)
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    RANGED_WEAPON_NAMES.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @armor.push(Armor.new(name, { defense: effect }, price: price, sell_value: sell_value))
    end
  end

  def armor_count
    RANGED_WEAPON_NAMES.length
  end

  def display_armor
    @armor.each_with_index(&Procs::DISPLAY)
  end

end
