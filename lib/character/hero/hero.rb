require_relative '../character'
require_relative '../../helpers/customize'
require_relative '../../helpers/inventory'
require_relative '../../helpers/display'
require_relative '../../helpers/equip'
require_relative '../../items/key'
require_relative '../../helpers/formulas'

require 'pry'
# TODO: Add More Hero Classes -> http://tvtropes.org/pmwiki/pmwiki.php/Main/FantasyCharacterClasses,
# http://www.giantitp.com/forums/showthread.php?204038-List-of-all-RPG-classes

class Hero < Character
  class << self
    include Display
    # Dynamically read the dir structure and get a list of all the hero jobs and classes
    def all_classes
      hash = {}
      Dir[File.join(Dir.pwd, 'lib', 'character', 'hero', '*/')].each do |job_file|
        job = File.basename(job_file).to_sym
        classes = Dir[File.join(job_file, 'specialization', '*.rb')].map { |file_name| File.basename(file_name, '.rb').classify }
        hash.store(job, classes.compact)
      end
      hash
    end

    # Create and instantiate a new hero. Using a kind of Factory pattern here since it seems to make a lot of sense
    def create
      display_hash_option all_classes, 'What class would you like to choose your hero from? '
      choice = gets.chomp.to_i
      base_class = CLASSES.keys[choice.pred] ? CLASSES.keys[choice.pred] : :soldier # TODO: Mayeb use default_option(:soldier) ?
      main_class = choose_array_option CLASSES[base_class]
      main_class.constantize.new # new hero
    end

    # Create the hero for the first time, or change the class and create a new one if called subsequently
    def create_new_hero
      puts "Are you sure you want to change your class?\n"
      puts "Your stats will reset and you will lose all of your current weapons, armor and dungeon accomplishments!\n"
      case choose_array_option %w(yes no), true
      when 1
        new_hero = create
        puts "Congratulations! You're class has changed to #{new_hero.main_class}!"
        new_hero
      else
        puts "Good! I thought the #{@main_class} was better anyway."
      end
    end
  end

  include Customize
  include Inventory
  include Equip
  include Formulas::HeroHelper

  attr_accessor :current_dungeon, :treasures_found
  attr_reader :inventory, :dungeon_level, :hints, :keys, :skip_battle_scenes, :base_class, :dungeons_conquered, :gender

  MAX_HINTS = 3
  CLASSES = all_classes

  def initialize(hero_args = {})
    super(hero_args) # make sure to initialize stuff abstracted into the character class
    @base_class = find_base_class # soldier, mage, ranged etc
    @gender = 'genderless'
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
    @skip_battle_scenes = false
    @dungeon_level = 1
    @current_dungeon = nil
    @dungeons_conquered = []
    @hints = 0 # Hints found by rolling a double with the dice
    @keys = [] # keys obtained when collecting all the hints
    @treasures_found = []
  end

  # Calculate the added attack from equipping weapons
  def weapon_bonus
    equipped_weapons.map(&:damage).reduce(0, :+)
  end

  # Calculate the added defense from wearing armor
  def armor_bonus
    equipped_armor.map(&:defense).reduce(0, :+)
  end

  # Make sure the attack has the damage done by equipped weapons as well
  def attack
    @attack + weapon_bonus
  end

  # Make sure the defense has the added defense provided by the equipped armor as well
  def defense
    @defense + armor_bonus
  end

  # Very useful to have. Finds the base class of the hero. Ex: (:soldier, :mage, :archer)
  def find_base_class
    if CLASSES.values.flatten.include? @main_class
      CLASSES.map { |klass, types| klass if types.include? @main_class }.compact.first
    else
      :soldier # default value # TODO Maybe raise an error?
    end
  end

  # A secret hint has been found by rolling a double. Reward the hero with a key
  def unlock_secret_hint
    puts 'You have found a secret hint!'
    add_hint
    # reset hints and obtain a key
    if @hints == MAX_HINTS
      reset_hints
      key = obtain_key(Key.unlock_with_hints)
      puts "Congratulations! You found all #{MAX_HINTS} hints, and have now obtained a #{key.name} key"
    end
  end

  # If the user has valid keys, then proceed to opening the treasure chests
  def unlock_treasure_chests
    if treasures_found.count == current_dungeon.total_treasure_chests
      puts "\nYou have already found all the treasures in this dungeon."
    elsif current_dungeon.treasures.count.zero?
      puts "\nThere are no treasures in this dungeon."
    else
      if @keys.any?
        puts "\nThere are a total of #{current_dungeon.treasures.count} treasures to be found in this dungeon\n"
        puts current_dungeon.treasures.map(&:type).inspect if $debug
        display_key_status
        sorted_keys_by_type = @keys.sort_by(&:name).slice_when { |key1, key2| key1.name != key2.name }
        display_amount_of_openable_chests_by_type
        sorted_keys_by_type.each do |array_of_types|
          type = array_of_types.first.type
          puts "\nDo you want to proceed with opening all #{type} treasure chests?"
          case choose_array_option yes_or_no_option, true
          when 1 then open_treasures(array_of_types)
          when 2 then puts "How are you going to pass on the #{type} treasures?! Oh well, Come back soon."
          else invalid
          end
        end
      else
        error 'You do not have any keys! Go explore the Dungeon a little more and come back.'
      end
    end
  end

  # Takes in an array of same keys and attempts to open the treasure chests which match the key type
  def open_treasures(keys)
    key_type = keys.first.type
    treasures = current_dungeon.treasures.select { |treasure| treasure.type == key_type }.first(keys.count)
    while treasure = treasures.shift
      used_key = @keys.delete(keys.shift)
      if used_key
        found_treasure = current_dungeon.treasures.delete(treasure)
        if found_treasure
          puts "Succesfully opened a #{treasure.type} treasure chest!\n"
          loot_treasure(found_treasure)
          @treasures_found << found_treasure
        else
          error 'Unable to open treasure chest.'
        end
      else
        error 'Unable to unlock treasure chest with key.'
      end
    end
  end

  # Open the treasure chest and get the reward!
  def loot_treasure(treasure)
    treasure.open
    loot = treasure.get_reward_for(self)
    case loot[:type]
    when 'money'
      puts "Congratulations! You have found #{loot[:reward]} gold"
      @money += loot[:reward]
    when 'item'
      puts "Congratulations! You have found the #{loot[:reward].class}, #{loot[:reward].name}"
      add_to_inventory(loot[:reward])
    else invalid
    end
  end

  # Show the user how many chests he/she can open with the current set of keys
  def display_amount_of_openable_chests_by_type
    print "\n"
    array_of_types = current_dungeon.treasures.map(&:type).sort.slice_when { |key1, key2| key1 != key2 }
    whitelisted_types = array_of_types.select { |array| @keys.select { |key| key.type == array.first }.count >= array.count }
    amount_of_openable_chests = whitelisted_types.inject(0) { |sum, type_array| sum + type_array.count }
    puts "You can currently open #{amount_of_openable_chests == current_dungeon.treasures.count ? amount_of_openable_chests : 'all'} treasure chests with your keys."
    array_of_types.each do |type_array|
      puts "#{type_array.count} #{type_array.first} treasure chest"
    end
  end

  # Show the user how many keys they currently possess and of what type
  def display_key_status
    puts "\nYou are currently in possession of #{@keys.count} keys."
    puts "#{get_keys_of_type(:bronze).count} Bronze keys\n#{get_keys_of_type(:silver).count} Silver keys\n#{get_keys_of_type(:gold).count} Gold keys\n"
  end

  # Filter keys by type
  def get_keys_of_type(type)
    @keys.select { |key| key.type == type }
  end

  # Keep track of how many hints the user has unlocked so far
  def add_hint
    @hints += 1
  end

  # Reset the hints back to 0 once they have already reached their limit (In this case, it's 3)
  def reset_hints
    @hints = 0
  end

  # The hero has obtained a new key! Add it to the list of keys already found
  def obtain_key(key)
    @keys.push(key)
    key
  end

  # The monster has been slain! Reap the benefits from the battlefield!
  def loot(monster)
    @money += monster.reward_money
    @experience += monster.reward_experience
    puts "You found #{monster.reward_money} gold and got #{monster.reward_experience} experience from slaying the enemy!"
  end

  # Proxy functions in order to make accessing the current_dungeon easier
  # The dungeon can only be completly explored if the hero has reached the total number of steps
  def dungeon_explored?
    @current_dungeon.steps_explored == @current_dungeon.total_steps
  end

  # Keep track of all the dungeons conquered by the hero
  def dungeons_conquered
    @dungeons_conquered.sort_by(&:level)
  end

  # Check if the current dungeon has been conquered or not
  def conquered_dungeon?
    @current_dungeon.conquered
  end

  # The hero has killed the dungeon gate keeper and can now advance to the next dungeon.
  # Make sure to keep track of the dungeon which was conquered as well
  def conquer_dungeon
    @current_dungeon.conquered = true
    @dungeons_conquered.push(@current_dungeon)
    reset_current_dungeon
    @dungeon_level += 1
    puts "Congratulations! You succesfully completed dungeon level #{@current_dungeon.level}"
  end

  # Check how many steps the hero has explored already in the dungeon. Defaults to 0
  def steps_walked
    @current_dungeon.steps_explored || 0
  end

  # Actually increase the steps taken in order to simulate the hero exploring the dungeon
  def walk(amount_of_steps)
    @current_dungeon.steps_explored += amount_of_steps
  end

  # Reset the current dungeon once completed, in order to gain access to the next one
  def reset_current_dungeon
    @current_dungeon = nil
  end

  # Give the hero the option to re-visit an already conquered dungeon.
  # However, the steps taken will not count since the dungeon has already been 100% explored.
  # Really good to just go back and battle monsters in order to level up.
  def change_dungeon_level
    if dungeons_conquered.any?
      puts 'What dungeon level would you like to visit?'
      # TODO: add validation for option
      option = choose_array_option dungeons_conquered.map { |dungeon| "Dungeon level #{dungeon.level}" }, true
      self.current_dungeon = dungeons_conquered[option.pred]
      Dungeon.enter(self)
    else
      puts "You have not conqeuered any dungeons..yet! Go get em'!"
    end
  end

  # Using the formulas module, make the hero level up according to his experience gained so far
  def level_up_attributes(level)
    @level += 1
    @max_hp = level_up_max_hp(level)
    @attack = level_up_att(level)
    @defense = level_up_def(level)
    @health = @max_hp # re-fill health to max_hp
  end

  # Only make sure the hero levels up if he has reached the exp limit of that specific level
  def level_up(exp)
    level_up_attributes(@level) if exp >= exp_needed(@level)
  end

  # Keep track of the exp gained. Also check if leveld up everytime exp is gained.
  def experience=(exp)
    @experience = exp
    level_up(@experience)
  end

  # Simulate a way for the hero to actually buy an item from the shop
  def buy(item)
    if @money >= item.price && add_to_inventory(item)
      @money -= item.price
      puts "Succesfully purchased #{item}!"
    else
      error "Unable to buy #{item.name}. You do not have enough money!"
    end
  end

  # Simulate a way for the hero to actually sell an item from the inventory back to the shop
  def sell(item)
    if remove_from_inventory(item)
      @money += item.sell_value
      puts "Succesfully sold #{item}!"
    else
      error "Unable to sell #{item.name}!"
    end
  end

  # Check inventory for potions, and it they exist give the hero the option of choosing which one to consume
  def use_potions
    if current_inventory_potions.any?
      puts 'Which potion would you like to consume?'
      index = choose_array_option(current_inventory_potions, true).pred
      potion = current_inventory_potions.delete_at(index)
      if potion
        self.health += potion.health
        puts "You are feeling refreshed. +#{potion.health} hp"
      else
        error 'Unable to consume potion.'
      end
    else
      error 'You do not have any potions available!'
    end
  end

  # Inventory main menu.
  def check_inventory
    puts 'Inside inventory! What would you like to do?'
    inventory_option = choose_array_option(inventory_options, true)
    case inventory_option
    when 1 then display_full_hero_status
    when 2 then equip_items
    when 3 then unequip_items
    when 4 then use_potions
    else invalid
    end
  end

  # TODO: Add a way to equip more than one item
  # Equip items from the hero's inventory
  def equip_items
    unless equippable_items?
      error 'You have nothing to equip!'
      return
    end
    puts 'What would you like to equip?'
    case choose_array_option %w(Weapons Armor), true
    when 1 then equip_weapon
    when 2 then equip_armor
    else invalid
    end
  end

  # Un-equip items from the hero's inventory
  def unequip_items
    unless equipped_items?
      error 'You have nothing to un-equip!'
      return
    end
    puts 'What would you like to un-equip?'
    case choose_array_option %w(Weapons Armor), true
    when 1 then unequip_weapon
    when 2 then unequip_armor
    else invalid
    end
  end

  # Nice little graphical way of representing the hero's progress thus far
  def display_full_hero_status
    display_stats
    display_inventory_items
    display_equipped_items
  end

  # Keep track of the hero's basic stats. Very important and handy to have especially before battles.
  def display_stats
    # TODO: Display the heros name and class as well here with a nice header like ~~~~
    puts "Base class: #{@base_class}"
    puts "specialization: #{@main_class}"
    puts "Dungeon level: #{@dungeon_level}"
    puts "Health: #{@health}"
    puts "Level: #{@level}"
    puts "Attack: #{@attack}"
    puts "Defense: #{@defense}"
    puts "Money: #{@money}"
    puts "Experience: #{@experience}\n"
  end
end # end class
