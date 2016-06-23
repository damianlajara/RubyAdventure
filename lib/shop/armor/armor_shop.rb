require_relative "../../helpers/attributes"
require_relative "../shop"

class ArmorShop < Shop
  attr_reader :armor
  def initialize(class_type)
    self.class.include "Attributes::Armor::#{class_type.capitalize}".constantize
    @armor = []
    @class_type = class_type
    @effect = BASE_EFFECT
    @price = BASE_PRICE
    @sell_value = BASE_SELL_VALUE
    initialize_armor_values
  end

  # TODO use the proc from mods.rb with DISPLAY_WITH_STATUS for this
  def display_formatted_armor
      armor.each_with_index { |armor, index| puts "#{index.next}) #{sprintf("%-23s", armor)} #{sprintf("%-10d", armor.defense)} #{sprintf("%-10d", armor.price)} #{sprintf("%-5d", armor.sell_value)} #{armor.description}" }
  end

  def armor_count
    armor_names.length
  end

  def display_armor
    armor.each_with_index(&Procs::DISPLAY)
  end

  private
  attr_reader :class_type

  def initialize_armor_values
    armor_names[class_type].each do |name|
      @effect += EFFECT_OFFSET
      @price += PRICE_OFFSET
      @sell_value += SELL_VALUE_OFFSET
      armor.push(Armor.new(name, { defense: @effect }, price: @price, sell_value: @sell_value))
    end
  end

end
