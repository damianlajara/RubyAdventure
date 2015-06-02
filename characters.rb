def display_hash_option(hash, saying = '')
  print saying
  hash.each_with_index { |(key, _value), index| print "#{index.next}) #{key} " }
end

def display_array_value_with_index(array)
  array.each_with_index { |value, index| puts "#{index.next}) #{value}" }
end

def choose_array_option(classes_array)
  display_array_value_with_index(classes_array)
  print "To choose a specification, enter the number that corresponds with the class you want: "
  choice = gets.chomp.to_i
  classes_array[choice.pred]
end

class Character
  include Validate
  attr_accessor :attack, :defense, :health, :max_hp, :level, :money, :experience
  attr_reader :name, :class, :gender, :base_class, :main_class, :weapon_count, :armor_count, :potion_count, 
  :equipped_weapon, :equipped_armor

  CLASSES = {
    soldier: %w(Barbarian Knight Paladin Samurai),
    mage: %w(Necromancer Wizard Illusionist Alcheemist),
    ranged: %w(Archer Gunner Tamer Elf)
  }

  GENDER = { male: 'Male', female: 'Female' }

  # def initialize(health, lvl, att, defense, money, exp)
  #   @health = health
  #   @level = lvl
  #   @attack = att
  #   @defense = defense
  #   @money = money
  #   @experience = exp
  # end

  def initialize(hero_args = {})
    @health = hero_args[:health] || 100
    @level = hero_args[:level] || 1
    @attack = hero_args[:attack] || 0
    @defense = hero_args[:defense] || 0
    @money = hero_args[:money] || 0
    @experience = hero_args[:exp] || 0
    @weapon_count = 0
    @armor_count = 0
    @potion_count = 0
  end

  def reset_stats
    #TODO Create validation in these methods which is why I called self inseat of accessing the var directly
    self.health = 100
    self.level = 1
    self.attack = 0
    self.defense = 0
    self.money = 0
    self.experience = 0
    self.max_hp = 100
    #self.dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end
  
  def customize_name
    print 'What would you like your character to be called? '
    @name = gets.chomp.capitalize
  end

  def customize_gender
    display_hash_option GENDER, 'What is your gender? '
    choice = gets.chomp.to_i
    @gender =
      case choice
      when 1
        GENDER[:male]
      when 2
        GENDER[:female]
      when 3
        print 'Enter your preferred gender: '
        gets.chomp.downcase
      else
        error 'Character -> customize_gender()'
      end
  end

  def customize_class
    display_hash_option CLASSES, 'What class would you like to choose your character from? '
    choice = gets.chomp.to_i

    @base_class =
      case choice
      when 1 then "soldier"
      when 2 then "mage"
      when 3 then "ranged"
      else error 'customize_class() -> base_class case statement'
      end

    @main_class =
      case choice
      when 1 then choose_array_option CLASSES[:soldier]
      when 2 then choose_array_option CLASSES[:mage]
      when 3 then choose_array_option CLASSES[:ranged]
      else error 'customize_class() -> main_class case statement'
      end
  end

  def game_options
    puts "\n#{'*' * 4} Game Options #{'*' * 4}\n"
    puts '1) Toggle Battle Scenes'
    puts '2) Change Class'
    puts '3) Change Gender'
    puts '4) Change Name'
    puts '5) Exit'
    option = gets.chomp.to_i
    case option
    when 1
      puts 'Do you want to disable all of the battle scenes? 1) Yes 2) No'
      scene_option = gets.chomp.to_i
      case scene_option
      when 1
        @skip = true
        puts 'Battle scenes have been disabled.'
      when 2
        @skip = false
        puts 'Battle scenes have been enabled.'
      else
        error 'game_options -> first case when 1 -> second case'
      end
    when 2
      puts "Are you sure you want to change your class?\n"
      puts "Your stats will reset and you will lose all of your current weapons and armor!\n"
      puts '1) Yes 2) No '
      class_choice = gets.chomp.to_i
      case class_choice
      when 1
        self.reset_stats
        customize_class
        puts "Congratulations! You're class has changed to #{@main_class}!"
      when 2
        puts "Good! I thought the #{@main_class} was better anyway."
      else
        error 'game_options -> first case when 2 -> second case'
      end
    when 3
      puts 'Are you sure you want to change your gender?'
      puts '1) Yes 2) No '
      gender_choice = gets.chomp.to_i
      case gender_choice
      when 1
        customize_gender
        puts "Congratulations! You're gender has changed to #{@gender}!"
      when 2
        puts 'Hmmm...I guess it was hard converting to something your not.'
      else
        error 'game_options -> first case when 3 -> second case'
      end
    when 4
      puts 'Are you sure you want to change your name?'
      puts '1) Yes 2) No '
      name_choice = gets.chomp.to_i
      case name_choice
      when 1
        customize_name
        puts "Congratulations! You're name has changed to #{@name}!"
      when 2
        puts 'Awww man...I was looking forward to see the weird name you were going to choose!'
      else
        error 'game_options -> first case when 4 -> second case'
      end
    when 5
      puts 'Exiting options menu...'
    else
      error 'game_options -> first case when 5'
    end
  end

  def print_welcome_message
    if @gender.index(/[aeiou]/) == 0
      puts "\nWelcome #{@name}! I see you are an #{@gender}, with a class of #{@main_class}!"
    else
      puts "\nWelcome #{@name}! I see you are a #{@gender}, with a class of #{@main_class}!"
    end
  end

  def customize
    customize_name
    customize_gender
    customize_class
    print_welcome_message
  end
end

class Hero < Character
  attr_reader :inventory, :dungeon_level
  #include Validate
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
    if !@equipped_weapon.nil?
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
      @equipped_weapon = item
      puts "Succesfully Equipped #{item.to_s}"
    elsif item.class == Armor && !self.armor_equipped?
      @equipped_armor = item
      puts "Succesfully Equipped #{item.to_s}"
    else
      error "equip() -> Error! You already have a weapon equipped"
    end
  end
  
  #TODO Make equipped_weapon and armor an array so you can use the mods instead of display_weapon_attributes (Bonus: You get to use index)
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
      self.display_weapons
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
      puts display_weapon_attributes(@equipped_weapon)
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
       self.display_weapons
       puts "To select a weapon to equip, enter the number that corresponds with the weapon you want: "
       weapon_option = gets.chomp.to_i
      item = (self.inventory[:current_weapons].values_at(weapon_option.pred)[0]) || nil
      if validate_num(weapon_option,@weapon_count) && !item.nil?
        self.equip(item)
      else
        error "equip_items() -> Error! Unable to equip weapon!"
      end
    when 2
      self.display_armor
      puts "To select an armor to equip, enter the number that corresponds with the armor you want: "
      armor_option = gets.chomp.to_i
      item = (self.inventory[:current_armor].values_at(armor_option.pred)[0]) || nil
    else error "equip_items() -> Error! Invalid Option!" #change to __method__ in each error
    end
  end

  def use_potions
  end
  
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
  def display_weapons()
    self.inventory[:current_weapons].each_with_index(&Procs::DISPLAY_WEAPON_WITH_STATUS)
  end

  def display_armor
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

# Soldier Class
class Barbarian < Hero
  def initialize
  end
end

class Knight < Hero
  def initialize
  end
end

class Paladin < Hero
  def initialize
  end
end

class Samurai < Hero
  def initialize
  end
end

# Mage Class
class Necromancer < Hero
  def initialize
  end
end

class Wizard < Hero
  def initialize
  end
end

class Illusionist < Hero
  def initialize
  end
end

class Alchemist < Hero
  def initialize
  end
end

# Ranged Class
class Archer < Hero
  def initialize
  end
end

class Gunner < Hero
  def initialize
  end
end

class Tamer  < Hero # uses pets to attack
  def initialize
  end
end

class Elf < Hero
  def initialize
  end
end





class Monster < Character
  def initialize(hero_args = {})
    #super
  end
end

class Wolf < Monster
  def initialize
  end
end

class Golem < Monster
  def initialize
  end
end

class FleshHunter < Monster
  def initialize
  end
end

class BoneReaver < Monster
  def initialize
  end
end

class MageLord < Monster
  def initialize
  end
end

class Executioner < Monster
  def initialize
  end
end

class DarkVessel < Monster
  def initialize
  end
end

class TorturedSoul < Monster
  def initialize
  end
end

class DarkCultist < Monster
  def initialize
  end
end
