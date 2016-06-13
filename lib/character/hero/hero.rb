require_relative "../character"

class Hero < Character
  attr_accessor :max_hp
  attr_reader :inventory, :dungeon_level
  def initialize(hero_args = {})
    super(hero_args) # make sure to initialize stuff abstracted into the character class
    @max_hp = 100
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end

  def reset_stats
    super
    @max_hp = 100
  end

  def experience=(xp)
    @experience = xp
    case xp
    when 0..50
      self.level += 1
    end
  end

  def buy(item)
    if self.money >= item.price && add_to_inventory(item)
      self.money -= item.price
      puts "Succesfully purchased #{item.to_s}!"
    else
      error "hero.buy() -> Error! You do not have enough money!"
    end
  end

  def sell(item)
    if remove_from_inventory(item)
      self.money += item.sell_value
      puts "Succesfully sold #{item.to_s}!"
    else
      error "hero.sell() -> Error! Unable to sell item!"
    end
  end

  def weapon_equipped?
    items_exist? @equipped_weapons
  end

  def armor_equipped?
    items_exist? @equipped_armor
  end

  def items_exist?(items)
    !(items.empty? || items.any?)
  end

  def equip(item)
    if item.class == Weapon && !weapon_equipped?
      @equipped_weapons.push(item)
      puts "Succesfully Equipped #{item.to_s}"
    elsif item.class == Armor && !armor_equipped?
      @equipped_armor.push(item)
      puts "Succesfully Equipped #{item.to_s}"
    else
      error "equip() -> Error! You already have a weapon equipped"
    end
  end

  def display_full_hero_status
    display_stats
    display_inventory_items
    display_equipped_items
  end

  # FIXME used self here so it can call the method instead of the instance var directly,
  # just in case we have any validation in those methods
  def display_stats
    # TODO Display the heros name and class as well here with a nice header like ~~~~
    puts "\nHealth: #{self.health}"
    puts "Level: #{self.level}"
    puts "Attack: #{self.attack}"
    puts "Defense: #{self.defense}"
    puts "Money: #{self.money}"
    puts "Experience: #{self.experience}\n"
  end

  def display_inventory_items
    print "\nWeapons In Inventory: "
    @inventory[:current_weapons].empty? ? display_empty : display_inventory_weapons

    print "Armor In Inventory:   "
    @inventory[:current_armor].empty?   ? display_empty : display_inventory_armor

    print "Potions In Inventory: "
    @inventory[:current_potions].empty? ? display_empty : display_inventory_potions
  end

  def display_equipped_items
    puts "\nEquipped Items!"
    print "Weapon: "
    weapon_equipped? ? display_equipped_weapons : display_empty
    print "Armor: "
    armor_equipped? ? display_equipped_armor : display_empty
  end

  def equip_items
    print "What would you like to equip?\n1) Weapons\n2) Armor "
    equip_choice = gets.chomp.to_i
    case equip_choice
    when 1
      display_inventory_weapons
      print "To select a weapon to equip, enter the number that corresponds with the weapon you want: "
      weapon_option = gets.chomp.to_i
      item = (@inventory[:current_weapons].values_at(weapon_option.pred).first) || nil
      if validate_num(weapon_option, @weapon_count) && !item.nil?
        self.equip(item)
      else
        error "equip_items() -> Error! Unable to equip weapon!"
      end
    when 2
      display_inventory_armor
      print "To select an armor to equip, enter the number that corresponds with the armor you want: "
      armor_option = gets.chomp.to_i
      item = (@inventory[:current_armor].values_at(armor_option.pred).first) || nil
    else error "equip_items() -> Error! Invalid Option!" #TODO change to __method__ in each error
    end
  end

  # TODO implement me
  def use_potions
  end

  # TODO implement me
  def sell_items
  end

  def check_inventory
    puts "Inside inventory! What would you like to do?"
    inventory_option = choose_array_option(inventory_options, true)
    # puts "1) Check Status\n2) Equip Items\n3) Use Potions\n4) Sell Items"
    # print "To select an option, enter the number that corresponds with the option you want: "
    # inventory_option = gets.chomp.to_i
    case inventory_option
    when 1 then display_full_hero_status
    when 2 then equip_items
    when 3 then use_potions
    when 4 then sell_items
    else error "check_inventory() -> Error! Invalid Option!"
    end
  end

  def inventory_options
    ["Check Status", "Equip Items", "Use Potions", "Sell Items"]
  end

  # TODO Make private, since only check_inventory should be using these methods
  def display_inventory_weapons
    "\n#{@inventory[:current_weapons].each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_inventory_armor
    "\n#{@inventory[:current_armor].each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end

  def display_inventory_potions
    "\n#{@inventory[:current_potions].each_with_index(&Procs::DISPLAY_POTION_WITH_STATUS)}"
  end

  def display_equipped_weapons
    "\n#{@equipped_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)}"
  end

  def display_equipped_armor
    "\n#{@equipped_armor.each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)}"
  end


  def add_to_inventory(item)
    success = false
    if item.class == Weapon
      # check weapon to see if hero class can use it
      @inventory[:current_weapons].push(item)
      @weapon_count += 1
      success = true
    elsif item.class == Armor
      # check armor
      @inventory[:current_armor].push(item)
      @armor_count += 1
      success = true
    elsif item.class == Potion
      @inventory[:current_potions].push(item)
      @potion_count += 1
      success = true
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
        @weapon_count -= 1
      else
        error 'remove_from_inventory() -> Weapon could not be removed'
        success = false
      end
    elsif item.class == Armor
      # Delete the armor that matches the item passed in
      @inventory[:current_armor].delete_if { |armor| armor.to_s == item.to_s }
      if !@inventory[:current_armor].include? item.to_s
        success = true
        @armor_count -= 1
      else
        error 'remove_from_inventory() -> 8armor could not be removed'
        success = false
      end
    elsif item.class == Potion
    # Delete the potion that matches the item passed in
      @inventory[:current_potions].delete_if { |potion| potion.to_s == item.to_s }
      if !@inventory[:current_potions].include? item.to_s
        success = true
        @potion_count -= 1
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

end #end class
