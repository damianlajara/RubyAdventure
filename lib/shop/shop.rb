require 'pry'
require_relative "../helpers/formatters"
require_relative "../helpers/mixins"
require_relative "../helpers/utility"
require_relative "../items/armor"
require_relative "../items/weapon"
require_relative "../items/potion"

class Shop
  include Formatter
  include Utility
  include Mixin

  # TODO Try to refactor this like the armor_names and weapon_names method
  POTION_NAMES = %w(Mommys_Tea Antidote_of_Life Red_Potion Imperial_Regeneration Oil_of_Health Holy_Light Serum_of_Rejuvination Elixir)

  def initialize
  end

  def armor_names
    {
      soldier: %w(Calcite Mirage Djinn Shape_Shifter Dark_Prism Fatal_Sith Devastator Override),
      mage: %w(Colossus Eternal_Vanguard Prism Valkyrie Trident Eclipse Lunar_Spirit Astral_Inducer),
      ranged: %w(Nightmare Ashura Ichimonji Lionheart Ascalon Nirvana Chaotic_Axis Ominous_Judgement)
    }
  end

  def weapon_names
    {
      soldier: %w(Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur),
      mage: %w(Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist),
      ranged: %w(Arondight Gugnir Susanoo Longinus Hrunting Clarent Shinigami Caliburn)
    }
  end

  public
   def display_weapon_choice(hero)
     shop = WeaponShop.new(hero.base_class.downcase)
     display_formatted_weapon_choice_header(hero.base_class.capitalize)
     display_graphical_line_break
     shop.display_formatted_weapons
     purchase_item(hero, shop.weapons)
   end

   def display_armor_choice(hero)
     shop = ArmorShop.new(hero.base_class.downcase)
     display_formatted_armor_choice_header(hero.base_class.capitalize)
     display_graphical_line_break
     shop.display_formatted_armor
     purchase_item(hero, shop.armor)
   end

   def display_potion_choice(hero)
     shop = PotionShop.new
     display_formatted_potion_choice_header
     display_graphical_line_break
     shop.display_formatted_potions
     purchase_item(hero, shop.potions)
   end

   def display_shop_items(hero)
     puts "What would you like to see?"
     case choose_array_option(shop_item_options, true)
     when 1 then display_weapon_choice(hero)
     when 2 then display_armor_choice(hero)
     when 3 then display_potion_choice(hero)
     else error "shop -> display_shop_items"
     end
   end

   def shop_item_options
     %w(Weapons Armor Potions)
   end

   def display_purchase_option
     puts "To purchase an item, enter the number that corresponds with item you want\n"
   end

   def purchase_item(hero, items)
     display_purchase_option
     purchase_choice = gets.chomp
     item = (items.values_at(purchase_choice.to_i.pred).first || nil)
     if purchase_choice.to_s =~ %r{[0-9]} && !item.nil?
       hero.buy(item)
     else
       error "purchase_item() -> Error that is not a valid answer!"
     end
   end

   def goto_shop(hero)
     puts "Welcome #{hero.name}, Feel free to look around the shop!"
     display_shop_items(hero)
   end

end
