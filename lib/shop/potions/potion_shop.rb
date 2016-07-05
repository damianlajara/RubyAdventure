require_relative '../shop'

class PotionShop < Shop
  attr_reader :potions

  def initialize(potions)
    @potions = potions
  end

  def potion_count
    potions.count
  end

  def display_potions
    potions.each_with_index(&Procs::DISPLAY)
  end

  def display_formatted_potions
    potions.each_with_index { |potion, index| puts "#{index.next}) #{sprintf('%-23s', potion)} #{sprintf('%-10d', potion.health)} #{sprintf('%-10d', potion.price)} #{sprintf('%-5d', potion.sell_value)} #{potion.description}" }
  end
end
