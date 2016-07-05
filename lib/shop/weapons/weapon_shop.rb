require_relative "../shop"

class WeaponShop < Shop
  attr_reader :weapons
  def initialize(weapons)
    @weapons = weapons
  end

  def display_formatted_weapons
    weapons.each_with_index { |weapon, index| puts "#{index.next}) #{sprintf("%-23s", weapon)} #{sprintf("%-10d", weapon.damage)} #{sprintf("%-10d", weapon.price)} #{sprintf("%-5d", weapon.sell_value)} #{weapon.description}" }
    puts "\n"
  end

  def weapon_count
    weapon_names.length
  end

  def display_weapons
    weapons.each_with_index(&Procs::DISPLAY)
  end

end
