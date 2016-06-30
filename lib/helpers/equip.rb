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
      puts "Succesfully Equipped #{item}"
    elsif item.class == Armor && !armor_equipped?
      item.equipped = true
      puts "Succesfully Equipped #{item}"
    else
      error 'You already have a weapon equipped'
    end
  end

  def equippable_items?
    !(current_inventory_weapons.empty? && current_inventory_armor.empty?)
  end

  def equip_weapon
    unless items_exist? current_inventory_weapons
      puts 'You have no weapons to equip!'
      return
    end
    display_inventory_weapons
    item = get_array_option_input(current_inventory_weapons)
    if item
      equip(item)
    else
      error 'Unable to equip weapon!'
    end
  end

  def equip_armor
    unless items_exist? current_inventory_armor
      puts 'You have no armor to equip!'
      return
    end
    display_inventory_armor
    item = get_array_option_input(current_inventory_armor)
    if item
      equip(item)
    else
      error 'Unable to equip armor!'
    end
  end

  def display_equipped_items
    puts "\nEquipped Items!"
    print 'Weapon: '
    weapon_equipped? ? display_equipped_weapons : display_empty
    print 'Armor: '
    armor_equipped? ? display_equipped_armor : display_empty
  end

  def equipped_weapons
    @inventory[:current_weapons].select(&:equipped)
  end

  def equipped_armor
    @inventory[:current_armor].select(&:equipped)
  end

  def display_equipped_weapons
    "\n#{equipped_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_equipped_armor
    "\n#{equipped_armor.each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end
end
