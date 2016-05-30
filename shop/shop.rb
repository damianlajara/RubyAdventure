class Shop
  #attr_reader :soldier_weapons, :mage_weapons, :archer_weapons, :soldier_armor, :mage_armor, :archer_armor, :potions
 #@@soldier_weapon_names = %w(Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur)
 SOLDIER_WEAPON_NAMES = %w(Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur)
 MAGE_WEAPON_NAMES = %w(Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist)
 RANGED_WEAPON_NAMES = %w(Arondight Gugnir Susanoo Longinus Hrunting Clarent Shinigami Caliburn)

 SOLDIER_ARMOR_NAMES = %w(Calcite Mirage Djinn Shape_Shifter Dark_Prism Fatal_Sith Devastator Override)
 MAGE_ARMOR_NAMES = %w(Colossus Eternal_Vanguard Prism Valkyrie Trident Eclipse Lunar_Spirit Astral_Inducer)
 RANGED_ARMOR_NAMES = %w(Nightmare Ashura Ichimonji Lionheart Ascalon Nirvana Chaotic_Axis Ominous_Judgement)

 POTION_NAMES = %w(Mommys_Tea Antidote_of_Life Red_Potion Imperial_Regeneration Oil_of_Health Holy_Light Serum_of_Rejuvination Elixir)

  def initialize
    puts "Initializing shop items ..."
  end

  def self.weapons(class_name = "all")
    case class_name
    when "all" then [SOLDIER_WEAPON_NAMES, MAGE_WEAPON_NAMES, RANGED_WEAPON_NAMES]
    when "soldier" then SOLDIER_WEAPON_NAMES
    when "mage" then MAGE_WEAPON_NAMES
    when "ranged" then RANGED_WEAPON_NAMES
    else error "shop -> self.weapons()"
    end
  end

  def self.armor(class_name = "all")
    case class_name
    when "all" then [SOLDIER_ARMOR_NAMES, MAGE_WEAPON_NAMES, RANGED_WEAPON_NAMES]
    when "soldier" then SOLDIER_ARMOR_NAMES
    when "mage" then MAGE_WEAPON_NAMES
    when "ranged" then RANGED_WEAPON_NAMES
    else error "shop -> self.armor()"
    end
  end

  public
   def display_weapon_choice(hero)
     shop =
     case hero.base_class.downcase
     when 'soldier' then SoldierWeaponShop.new
     when 'mage'    then MageWeaponShop.new
     when 'ranged'  then RangedWeaponShop.new
     else error "display_weapon_choice() -> case statement"
     end

     puts "\n# #{sprintf("%19s", hero.base_class.capitalize << " Weapon Name")}#{sprintf("%10s", "Damage")} #{sprintf("%10s", "Price")} #{sprintf("%13s", "Sell_Value")}\n"
     puts "#{("*~"*29).chop}"

     #TODO use the proc from mods.rb with DISPLAY_WITH_STATUS for this
     shop.weapons.each_with_index { |weapon, index| puts "#{index.next}) #{sprintf("%-23s", weapon)} #{sprintf("%-10d", weapon.damage)} #{sprintf("%-10d", weapon.price)} #{sprintf("%-5d", weapon.sell_value)} #{weapon.description}" }
     puts "\n"

     purchase_item(hero, shop.weapons)
   end

   def display_armor_choice(hero)
     shop =
     case hero.base_class.downcase
     when 'soldier' then SoldierArmorShop.new
     when 'mage'    then MageArmorShop.new
     when 'ranged'  then RangedArmorShop.new
     else error "display_armor_choice() -> case statement"
     end

     puts "\n# #{sprintf("%19s", hero.base_class.capitalize << " Armor Name")}#{sprintf("%10s", "Defense")} #{sprintf("%10s", "Price")} #{sprintf("%13s", "Sell_Value")}\n"
     puts "#{("*~"*29).chop}"

     shop.armor.each_with_index { |armor, index| puts "#{index.next}) #{sprintf("%-23s", armor)} #{sprintf("%-10d", armor.defense)} #{sprintf("%-10d", armor.price)} #{sprintf("%-5d", armor.sell_value)} #{armor.description}" }

     purchase_item(hero, shop.armor)

   end

   def display_potion_choice(hero)
     puts "\n# #{sprintf("%12s", "Potion Name")}#{sprintf("%17s", "Health")} #{sprintf("%10s", "Price")} #{sprintf("%13s", "Sell_Value")}\n"
     puts "#{("*~"*29).chop}"
     shop = PotionShop.new

     shop.potions.each_with_index { |potion, index| puts "#{index.next}) #{sprintf("%-23s", potion)} #{sprintf("%-10d", potion.health)} #{sprintf("%-10d", potion.price)} #{sprintf("%-5d", potion.sell_value)} #{potion.description}" }

     purchase_item(hero, shop.potions)
   end

   def display_shop_items(hero)
     print "What would you like to see? "
     print "1) Weapons 2) Armor 3) Potions "
     main_choice = gets.chomp.to_i
     case main_choice
     when 1
       display_weapon_choice(hero)
       #display_weapon_choice('soldier')
       #display_weapon_choice('mage')
       #display_weapon_choice('ranged')

     when 2
       display_armor_choice(hero)
       #display_armor_choice('soldier')
       #display_armor_choice('mage')
       #display_armor_choice('ranged')
     when 3
       display_potion_choice(hero)

     else error "shop -> display_shop_items"
     end

   end

   def display_purchase_option
     puts "To purchase an item, enter the number that corresponds with item you want\n"
   end

   def purchase_item(hero, items)
     display_purchase_option
     purchase_choice = gets.chomp
     item = (items.values_at(purchase_choice.to_i.pred)[0] || nil)
     if purchase_choice.to_s =~ %r{[0-9]} && !item.nil?
       hero.buy(item)
     else
       error "purchase_item() -> Error that is not a valid answer!"
     end
   end

   def confirm_purchase(item)
     puts "Are you sure you want to buy #{item} ? Y/N"
   end

   def goto_shop(hero)
     puts "Welcome #{hero.name}, Feel free to look around the shop!"
     display_shop_items(hero)
   end

end
