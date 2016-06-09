require_relative "../character"

class Hero < Character
  attr_reader :inventory, :dungeon_level
  def initialize(hero_args = {})
    super
    @max_hp = 100
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
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
    if !@equipped_weapons.empty? || !@equipped_weapons.any? {|weapon| weapon.nil?}
      true
    else
      false
    end
  end

  def armor_equipped?
    if @equipped_armor
      true
    else
      false
    end
  end

  def equip(item)
    if item.class == Weapon && !self.weapon_equipped?
      @equipped_weapons.push(item)
      puts "Succesfully Equipped #{item.to_s}"
    elsif item.class == Armor && !self.armor_equipped?
      @equipped_armor.push(item)
      puts "Succesfully Equipped #{item.to_s}"
    else
      error "equip() -> Error! You already have a weapon equipped"
    end
  end

  # TODO Make equipped_weapons and armor an array so you can use the mods instead of display_weapon_attributes (Bonus: You get to use index)
  def display_weapon_attributes(weapon)
    puts "#{sprintf("%-16s", weapon)} Damage: #{sprintf("%-8d", weapon.damage)} Price: #{sprintf("%-8d", weapon.price)} Sell_Value: #{sprintf("%-8d", weapon.sell_value)} Description: #{weapon.description}"
  end

  def display_armor_attributes(armor)
    puts "#{sprintf("%-16s", armor)} Defense: #{sprintf("%-7d", armor.defense)} Price: #{sprintf("%-8d", armor.price)} Sell_Value: #{sprintf("%-8d", armor.sell_value)} Description: #{armor.description}"
  end

  def display_status
    puts "Health: #{self.health}"
    puts "Level: #{self.level}"
    puts "Attack: #{self.attack}"
    puts "Defense: #{self.defense}"
    puts "Money: #{self.money}"
    puts "Experience: #{self.experience}\n"

    print "\nWeapons In Inventory: "
    if self.inventory[:current_weapons].length > 0
      puts "\n"
      self.display_inventory_weapons
    else
      print "Empty!\n"
    end

    print "Armor In Inventory: "
    if self.inventory[:current_armor].length > 0
      puts "\n"
      self.display_armor
    else
      print "Empty!\n"
    end

    print "Potions In Inventory: "
    if self.inventory[:current_potions].length > 0
      puts "\n"
      self.display_potions
    else
      print "Empty!\n"
    end

    puts "\nEquipped Items!"
    print "Weapon: "
    if self.weapon_equipped?
      puts "\n"
      #puts display_weapon_attributes(@equipped_weapons)
      display_equipped_weapons
    else
      print "No Weapon Equipped!\n"
    end
    puts "\n"
    print "Armor: "
    if self.armor_equipped?
      puts "\n"
      puts @equipped_armor.to_s
    else
      print "No Armor Equipped!\n"
    end
  end

  def equip_items
    puts "What would you like to equip?\n1) Weapons\n2) Armor "
    equip_choice = gets.chomp.to_i
    case equip_choice
    when 1
       self.display_inventory_weapons
       puts "To select a weapon to equip, enter the number that corresponds with the weapon you want: "
       weapon_option = gets.chomp.to_i
      item = (self.inventory[:current_weapons].values_at(weapon_option.pred)[0]) || nil
      if validate_num(weapon_option,@weapon_count) && !item.nil?
        self.equip(item)
      else
        error "equip_items() -> Error! Unable to equip weapon!"
      end
    when 2
      self.display_inventory_armor
      puts "To select an armor to equip, enter the number that corresponds with the armor you want: "
      armor_option = gets.chomp.to_i
      item = (self.inventory[:current_armor].values_at(armor_option.pred)[0]) || nil
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
    puts "1) Check Status\n2) Equip Items\n3) Use Potions\n4) Sell Items"
    puts "To select an option, enter the number that corresponds with the option you want: "
    inventory_option = gets.chomp.to_i
    case inventory_option
    when 1 then display_status
    when 2 then equip_items
    when 3 then use_potions
    when 4 then sell_items
    else error "check_inventory() -> Error! Invalid Option!"
    end
  end

  #TODO Make private, since only check_inventory should be using these methods
  def display_inventory_weapons
    self.inventory[:current_weapons].each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)
  end

  def display_inventory_armor
    self.inventory[:current_armor].each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)
  end

  def display_equipped_weapons
    @equipped_weapons.each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)
  end

  def display_equipped_armor
    self.inventory[:current_armor].each_with_index(&Procs::DISPLAY_ARMOR_WITH_STATUS)
  end

  def display_potions
    self.inventory[:current_potions].each_with_index(&Procs::DISPLAY_POTION_WITH_STATUS)
  end


  def add_to_inventory(item)
    success = false
    if item.class == Weapon
      # check weapon to see if hero class can use it
      @inventory[:current_weapons].push(item)
      puts "Item has been succesfully added to your inventory!"
      @weapon_count += 1
      success = true
    elsif item.class == Armor
      # check armor
      @inventory[:current_armor].push(item)
      puts "Item has been succesfully added to your inventory!"
      @armor_count += 1
      success = true
    elsif item.class == Potion
      @inventory[:current_potions].push(item)
       puts "Item has been succesfully added to your inventory!"
       @potion_count += 1
       success = true
    else
      error 'add_to_inventory() -> item has no valid type (class)'
      success = false
    end
    success
  end

  #TODO Use the StringConstants Module and replace these strings (DRY Principle)
  def remove_from_inventory(item)
    success = false
    if item.class == Weapon
      # Delete the weapon that matches the item passed in
      @inventory[:current_weapons].delete_if { |weapon| weapon.to_s == item.to_s }
      if !@inventory[:current_weapons].include? item.to_s
        puts "Item was succesfully removed from the inventory"
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
        puts "Item was succesfully removed from the inventory"
        success = true
        @armor_count -= 1
      else
        error 'remove_from_inventory() -> armor could not be removed'
         success = false
      end
    elsif item.class == Potion
    # Delete the potion that matches the item passed in
      @inventory[:current_potions].delete_if { |potion| potion.to_s == item.to_s }
      if !@inventory[:current_potions].include? item.to_s
        puts "Item was succesfully removed from the inventory"
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
    success
  end

end #end class
