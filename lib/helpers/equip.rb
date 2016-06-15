module Equip
  def weapon_equipped?
    items_exist? equipped_weapons
  end

  def armor_equipped?
    items_exist? equipped_armor
  end

  def items_exist?(items)
    items.any?
  end

  def equip(item)
    if item.class == Weapon && !weapon_equipped?
      item.equipped = true
      puts "Succesfully Equipped #{item.to_s}"
    elsif item.class == Armor && !armor_equipped?
      item.equipped = true
      puts "Succesfully Equipped #{item.to_s}"
    else
      error "equip() -> Error! You already have a weapon equipped"
    end
  end

  def display_equipped_items
    puts "\nEquipped Items!"
    print "Weapon: "
    weapon_equipped? ? display_equipped_weapons : display_empty
    print "Armor: "
    armor_equipped? ? display_equipped_armor : display_empty
  end

  def equipped_weapons
    @inventory[:current_weapons].select { |weapon| weapon.equipped }
  end

  def equipped_armor
    @inventory[:current_armor].select { |armor| armor.equipped }
  end

  def display_equipped_weapons
    "\n#{equipped_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_equipped_armor
    "\n#{equipped_armor.each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end

end
