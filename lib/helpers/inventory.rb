module Inventory
  # TODO: Make private, since only check_inventory should be using these methods
  def display_inventory_weapons
    current_inventory_weapons.empty? ? display_empty : "\n#{current_inventory_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_inventory_armor
    current_inventory_armor.empty? ? display_empty : "\n#{current_inventory_armor.each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end

  def display_inventory_potions
    current_inventory_potions.empty? ? display_empty : "\n#{current_inventory_potions.each_with_index(&Procs::DISPLAY_POTION_WITH_STATUS)}"
  end

  # Weapons that are not equipped
  def current_inventory_weapons
    @inventory[:current_weapons].select { |weapon| !weapon.equipped }
  end

  # armor that is not equipped
  def current_inventory_armor
    @inventory[:current_armor].select { |armor| !armor.equipped }
  end

  def current_inventory_potions
    @inventory[:current_potions]
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

  def add_to_inventory(item)
    success = false
    container = temp_inventory
    key = item.class.name.downcase.to_sym
    # Make sure it is a valid type from temp_inventory
    if container.keys.include? key
      # Do not add if item already exists in inventory
      if container[key].select { |my_item| my_item.to_s == item.to_s }.none?
        container[key].push(item)
        puts "#{item.name} has been succesfully added to your inventory!"
        success = true
      else
        error 'You already have this item!'
      end
    else
      error "Unable to identify item class of type #{key}"
    end
    success
  end

  def remove_from_inventory(item)
    success = false
    container = temp_inventory
    key = item.class.name.downcase.to_sym
    # Make sure it is a valid type from temp_inventory
    if container.keys.include? key
      container[key].delete_if { |item_to_delete| item_to_delete.to_s == item.to_s }
      if !container[key].include? item.to_s
        puts "#{item.name} was succesfully removed from the inventory"
        success = true
      else
        error 'Item could not be removed'
      end
    else
      error "Unable to identify item class of type #{key}"
    end
    success
  end

  # TODO: add a way to add other items to inventory like treasure.
  def temp_inventory
    inventory_bag = Hash.new([])
    inventory_bag.store(:weapon, @inventory[:current_weapons])
    inventory_bag.store(:armor, @inventory[:current_armor])
    inventory_bag.store(:potion, @inventory[:current_potions])
    inventory_bag
  end

  def display_inventory_items
    print "\nWeapons In Inventory: "
    display_inventory_weapons
    print 'Armor In Inventory:   '
    display_inventory_armor
    print 'Potions In Inventory: '
    display_inventory_potions
  end

  def inventory_options
    ['Check Status', 'Equip Items', 'Use Potions', 'Sell Items']
  end
end
