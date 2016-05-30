require_relative "../../helpers/attributes"
require_relative "../shop"

# TODO include the mods for these also
  class SoldierArmorShop < Shop
    include Attributes::Armor::Soldier
    attr_reader :armor
    def initialize
      @armor = []
      #SOLDIER_ARMOR_NAMES = %w(Calcite Mirage Djinn Shape_Shifter Dark_Prism Fatal_Sith Devastator Override)
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      SOLDIER_ARMOR_NAMES.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @armor.push(Armor.new(name, { defense: effect }, price: price, sell_value: sell_value))
      end
    end

    def armor_count
      SOLDIER_ARMOR_NAMES.length
    end

    def display_armor
      @armor.each_with_index(&Procs::DISPLAY)
    end
  end
