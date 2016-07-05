require_relative "../shop"

class ArmorShop < Shop
  attr_reader :armor

  def initialize(armor)
    @armor = armor
  end

  # TODO use the proc from mods.rb with DISPLAY_WITH_STATUS for this
  def display_formatted_armor
    armor.each_with_index { |armor, index| puts "#{index.next}) #{sprintf("%-23s", armor)} #{sprintf("%-10d", armor.defense)} #{sprintf("%-10d", armor.price)} #{sprintf("%-5d", armor.sell_value)} #{armor.description}" }
  end

  def armor_count
    armor.count
  end

  def display_armor
    armor.each_with_index(&Procs::DISPLAY)
  end

end
