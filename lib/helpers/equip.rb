module Equip

  # TODO: Make these methods private

  def weapon_equipped?
    items_exist? equipped_weapons
  end

  def armor_equipped?
    items_exist? equipped_armor
  end

  def items_exist?(items)
    items.any?
  end

  def display_equipped_weapons
    "\n#{equipped_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_equipped_armor
    "\n#{equipped_armor.each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end

  def equip(item)
   if (item.class == Weapon && !weapon_equipped?) || (item.class == Armor && !armor_equipped?)
     item.equipped = true
     puts "Succesfully Equipped #{item}"
   else
     error "You already have a #{item.class} equipped"
   end
  end

  def unequip(item)
    if (item.class == Weapon && weapon_equipped?) || (item.class == Armor && armor_equipped?)
      item.equipped = false
      puts "Succesfully Un-equipped #{item.name}"
    else
      error "You do not have a #{item.class} equipped"
    end
  end

  # Interface Methods

  def equipped_items?
    equipped_weapons.any? || equipped_armor.any?
  end

  def equipped_weapons
    @inventory[:current_weapons].select(&:equipped)
  end

  def equipped_armor
    @inventory[:current_armor].select(&:equipped)
  end

  def equippable_items?
    # !(A && B) == !A || !B (De Morgan's law)
    !(current_inventory_weapons.empty? && current_inventory_armor.empty?)
  end

  def equip_weapon
    unless items_exist? current_inventory_weapons
      error 'You have no weapons to equip!'
      return
    end
    display_inventory_weapons
    item = get_array_option_input(current_inventory_weapons)
    item ? equip(item) : error('Unable to equip weapon!')
  end

  def unequip_weapon
    unless items_exist? equipped_weapons
      error 'You have no weapons to un-equip!'
      return
    end
    display_equipped_weapons
    item = get_array_option_input(equipped_weapons)
    item ? unequip(item) : error('Unable to un-equip weapon!')
  end

  def equip_armor
    unless items_exist? current_inventory_armor
      error 'You have no armor to equip!'
      return
    end
    display_inventory_armor
    item = get_array_option_input(current_inventory_armor)
    item ? equip(item) : error('Unable to equip armor!')
  end

  def unequip_armor
    unless items_exist? equipped_armor
      error 'You have no armor to un-equip!'
      return
    end
    display_equipped_armor
    item = get_array_option_input(equipped_armor)
    item ? unequip(item) : error('Unable to un-equip armor!')
  end

  def display_equipped_items
    puts "\nEquipped Items!"
    print 'Weapon: '
    weapon_equipped? ? display_equipped_weapons : display_empty
    print 'Armor: '
    armor_equipped? ? display_equipped_armor : display_empty
  end
end
