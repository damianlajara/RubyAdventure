module Inventory
  # TODO Make private, since only check_inventory should be using these methods
  def display_inventory_weapons
    "\n#{current_inventory_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_inventory_armor
    "\n#{current_inventory_armor.each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end

  def display_inventory_potions
    "\n#{@inventory[:current_potions].each_with_index(&Procs::DISPLAY_POTION_WITH_STATUS)}"
  end

  # Weapons that are not equipped
  def current_inventory_weapons
    @inventory[:current_weapons].select { |weapon| !weapon.equipped }
  end
  
  # armor that is not equipped
  def current_inventory_armor
    @inventory[:current_armor].select { |armor| !armor.equipped  }
  end

  def weapon_count
    @inventory[:current_weapons].count
  end

  def armor_count
    @inventory[:current_armor].count
  end

  def potion_count
    @inventory[:current_potions].count
  end

  # TODO add a way to add other items to inventory like treasure.
  def add_to_inventory(item)
    success = true
    if item.class == Weapon
      # check weapon to see if hero class can use it
      @inventory[:current_weapons].push(item)
    elsif item.class == Armor
      # check armor
      @inventory[:current_armor].push(item)
    elsif item.class == Potion
      @inventory[:current_potions].push(item)
    else
      error 'add_to_inventory() -> item has no valid type (class)'
      success = false
    end
    puts "Item has been succesfully added to your inventory!" if success
    success
  end

  #TODO Use the StringConstants Module and replace these strings (DRY Principle)
  def remove_from_inventory(item)
    success = false
    if item.class == Weapon
      # Delete the weapon that matches the item passed in
      @inventory[:current_weapons].delete_if { |weapon| weapon.to_s == item.to_s }
      if !@inventory[:current_weapons].include? item.to_s
        success = true
      else
        error 'remove_from_inventory() -> Weapon could not be removed'
        success = false
      end
    elsif item.class == Armor
      # Delete the armor that matches the item passed in
      @inventory[:current_armor].delete_if { |armor| armor.to_s == item.to_s }
      if !@inventory[:current_armor].include? item.to_s
        success = true
      else
        error 'remove_from_inventory() -> 8armor could not be removed'
        success = false
      end
    elsif item.class == Potion
    # Delete the potion that matches the item passed in
      @inventory[:current_potions].delete_if { |potion| potion.to_s == item.to_s }
      if !@inventory[:current_potions].include? item.to_s
        success = true
      else
        error 'remove_from_inventory() -> potion could not be removed'
        success = false
      end
    else
      error 'remove_from_inventory() -> item has no valid type (class)'
      success = false
    end
    puts "Item was succesfully removed from the inventory" if success
    success
  end

  def display_inventory_items
    print "\nWeapons In Inventory: "
    @inventory[:current_weapons].empty? ? display_empty : display_inventory_weapons

    print "Armor In Inventory:   "
    @inventory[:current_armor].empty?   ? display_empty : display_inventory_armor

    print "Potions In Inventory: "
    @inventory[:current_potions].empty? ? display_empty : display_inventory_potions
  end

  def inventory_options
    ["Check Status", "Equip Items", "Use Potions", "Sell Items"]
  end

end
