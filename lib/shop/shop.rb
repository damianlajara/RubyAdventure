require 'pry'
require_relative '../helpers/formatters'
require_relative '../helpers/display'
require_relative '../helpers/utility'
require_relative '../helpers/all_items'
require_relative '../items/armor'
require_relative '../items/weapon'
require_relative '../items/potion'

class Shop
  include Formatter
  include Utility
  include Display
  include AllItems

  def initialize
  end

  # TODO: Try to refactor these choice methods - they have a lot of similar functionality
  def display_weapon_choice(hero, type = 'purchase')
    if type == 'purchase'
      shop = WeaponShop.new get_items_of_type(:weapon, hero.base_class.downcase)
      display_formatted_weapon_choice_header(hero.base_class.capitalize)
      shop.display_formatted_weapons
      item = select_item(shop.weapons)
      purchase_item(hero, item)
    elsif type == 'sell'
      if hero.current_inventory_weapons.any?
        hero.display_inventory_weapons
        item = select_item(hero.current_inventory_weapons)
        sell_item(hero, item)
      else
        error 'You do not have any weapons to sell!'
      end
    else
      error "Undefined type #{type} for trying to display weapons"
    end
  end

  def display_armor_choice(hero, type = 'purchase')
    if type == 'purchase'
      shop = ArmorShop.new get_items_of_type(:armor, hero.base_class.downcase)
      display_formatted_armor_choice_header(hero.base_class.capitalize)
      shop.display_formatted_armor
      item = select_item(shop.armor)
      purchase_item(hero, item)
    elsif type == 'sell'
      if hero.current_inventory_armor.any?
        hero.display_inventory_armor
        item = select_item(hero.current_inventory_armor)
        sell_item(hero, item)
      else
        error 'You do not have any armor to sell!'
      end
    else
      error "Undefined type #{type} for trying to display armor"
    end
  end

  def display_potion_choice(hero, type = 'purchase')
    if type == 'purchase'
      shop = PotionShop.new(get_items_of_type :potion)
      display_formatted_potion_choice_header
      shop.display_formatted_potions
      item = select_item(shop.potions)
      purchase_item(hero, item)
    elsif type == 'sell'
      if hero.current_inventory_potions.any?
        hero.display_inventory_potions
        item = select_item(hero.current_inventory_potions)
        sell_item(hero, item)
      else
        error 'You do not have any potions to sell!'
      end
    else
      error "Undefined type #{type} for trying to display potions"
    end
  end

  def display_shop_items(hero)
    puts 'What would you like to do?'
    case choose_array_option(['purchase items', 'sell items'], true)
    when 1 then look_around_and('purchase', hero)
    when 2 then look_around_and('sell', hero)
    else invalid
    end
  end

  def look_around_and(shop_type, hero)
    case shop_type
    when 'purchase' then purchase_items(hero)
    when 'sell' then sell_items(hero)
    else invalid
    end
  end

  def purchase_items(hero)
    puts 'What type of item are you looking to purchase?'
    case choose_array_option(shop_item_options, true)
    when 1 then display_weapon_choice(hero)
    when 2 then display_armor_choice(hero)
    when 3 then display_potion_choice(hero)
    else invalid
    end
  end

  def sell_items(hero)
    if hero.inventory_empty?
      error 'You have nothing to equip!'
      return
    end
    puts 'What type of item are you looking to sell?'
    case choose_array_option(shop_item_options, true)
    when 1 then display_weapon_choice(hero, 'sell')
    when 2 then display_armor_choice(hero, 'sell')
    when 3 then display_potion_choice(hero, 'sell')
    else invalid
    end
  end

  def shop_item_options
    %w(Weapons Armor Potions)
  end

  def select_item(items)
    get_array_option_input items
  end

  def purchase_item(hero, item)
    hero.buy(item)
  end

  def sell_item(hero, item)
    hero.sell(item)
  end

  def goto_shop(hero)
    puts "Welcome #{hero.name}, Feel free to look around the shop!"
    display_shop_items(hero)
  end
end
