require_relative "../../helpers/attributes"
require_relative "../shop"

class WeaponShop < Shop
  attr_reader :weapons
  def initialize(class_type)
    self.class.include Object.const_get("Attributes::Weapon::#{class_type.capitalize}")
    @weapons = []
    @class_type = class_type
    @effect = BASE_EFFECT
    @price = BASE_PRICE
    @sell_value = BASE_SELL_VALUE
    initialize_weapon_values
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

  private
  attr_reader :class_type

  def initialize_weapon_values
    weapon_names[class_type].each do |name|
      @effect += EFFECT_OFFSET
      @price += PRICE_OFFSET
      @sell_value += SELL_VALUE_OFFSET
      weapons.push(Weapon.new(name, { damage: @effect }, price: @price, sell_value: @sell_value))
    end
  end

end
