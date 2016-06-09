require_relative "../../helpers/attributes"
require_relative "../shop"

class PotionShop < Shop
  include Attributes::Potion
  attr_reader :potions

  def initialize
    @potions = []
    @effect = BASE_EFFECT
    @price = BASE_PRICE
    @sell_value = BASE_SELL_VALUE
    initialize_potion_values
  end

  def potion_count
    POTION_NAMES.count
  end

  def display_potions
    @potions.each_with_index(&Procs::DISPLAY)
  end

  def display_formatted_potions
    @potions.each_with_index { |potion, index| puts "#{index.next}) #{sprintf("%-23s", potion)} #{sprintf("%-10d", potion.health)} #{sprintf("%-10d", potion.price)} #{sprintf("%-5d", potion.sell_value)} #{potion.description}" }
  end

  private
  def initialize_potion_values
    POTION_NAMES.each do |name|
      @effect += EFFECT_OFFSET
      @price += PRICE_OFFSET
      @sell_value += SELL_VALUE_OFFSET
      @potions.push(Potion.new(name, { health: @effect }, price: @price, sell_value: @sell_value))
    end
  end

end
