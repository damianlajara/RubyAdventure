require_relative '../character'
require_relative '../../helpers/customize'
require_relative '../../helpers/inventory'
require_relative '../../helpers/equip'
require_relative '../../items/key'
require_relative '../../helpers/formulas'

require "pry"
# TODO: Add More Hero Classes -> http://tvtropes.org/pmwiki/pmwiki.php/Main/FantasyCharacterClasses,
# http://www.giantitp.com/forums/showthread.php?204038-List-of-all-RPG-classes
class Hero < Character

  class << self
    def all_classes
      hash = {}
      Dir[File.join(Dir.pwd, 'lib', 'character', 'hero', '*/')].each do |job_file|
        job = File.basename(job_file).to_sym
        classes = Dir[File.join(job_file, 'specialization', '*.rb')].map { |file_name| File.basename(file_name, '.rb').classify }
        hash.store(job, classes.compact)
      end
      hash
    end

    def create
      display_hash_option all_classes, 'What class would you like to choose your hero from? '
      choice = gets.chomp.to_i
      base_class = CLASSES.keys[choice.pred] ? CLASSES.keys[choice.pred] : :soldier # TODO: Mayeb use default_option(:soldier) ?
      main_class = choose_array_option CLASSES[base_class]
      new_hero = main_class.constantize.new
    end
  end

  include Customize
  include Inventory
  include Equip
  include Formulas::HeroHelper

  attr_accessor :current_dungeon, :treasures_found
  attr_reader :inventory, :dungeon_level, :hints, :keys, :skip_battle_scenes, :base_class

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
    @dungeons_conquered = [Dungeon.new('mountain', 3), Dungeon.new('underworld', 1), Dungeon.new('forest', 2)] # TODO: Remove this dummy data. For debugging purposes
    @hints = 0 # Hints found by rolling a double with the dice
    @keys = [] # keys attained when collecting all the hints
    @treasures_found = 0
  end

  def find_base_class
    if CLASSES.values.flatten.include? @main_class
      CLASSES.map { |klass, types| klass if types.include? @main_class }.compact.first
    else
      :soldier # default value # TODO Maybe raise an error?
    end
  end

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

  def add_hint
    @hints += 1
  end

  def reset_hints
    @hints = 0
  end

  def obtain_key(key)
    @keys.push(key)
    key
  end

  def loot(monster)
    @money += monster.reward_money
    @experience += monster.reward_experience
    puts "You found #{monster.reward_money} gold and got #{monster.reward_experience} experience from slaying the enemy!"
  end

  def dungeon_explored?
    @current_dungeon.steps_explored == @current_dungeon.total_steps
  end

  def dungeons_conquered
    @dungeons_conquered.sort_by(&:level)
  end

  def conquered_dungeon?
    @current_dungeon.conquered
  end

  def conquer_dungeon
    @current_dungeon.conquered = true
    @dungeons_conquered.push(@current_dungeon)
    reset_current_dungeon
    @dungeon_level += 1
    puts "Congratulations! You succesfully completed dungeon level #{@current_dungeon.level}"
  end

  def steps_walked
    @current_dungeon.steps_explored || 0
  end

  def walk(amount_of_steps)
    @current_dungeon.steps_explored += amount_of_steps
  end

  def reset_current_dungeon
    @current_dungeon = nil
  end

  def level_up_attributes(level)
    @level += 1
    @max_hp = level_up_max_hp(level)
    @attack = level_up_att(level)
    @defense = level_up_def(level)
    @health = @max_hp # re-fill health to max_hp
  end

  def level_up(exp)
    level_up_attributes(@level) if exp >= exp_needed(@level)
  end

  def experience=(exp)
    @experience = exp
    level_up(@experience)
  end

  def buy(item)
    if @money >= item.price && add_to_inventory(item)
      @money -= item.price
      puts "Succesfully purchased #{item}!"
    else
      error 'hero.buy() -> Error! You do not have enough money!'
    end
  end

  def sell(item)
    if remove_from_inventory(item)
      @money += item.sell_value
      puts "Succesfully sold #{item}!"
    else
      error 'hero.sell() -> Error! Unable to sell item!'
    end
  end

  # TODO: implement me
  def use_potions
  end

  # TODO: implement me
  def sell_items
  end

  def check_inventory
    puts 'Inside inventory! What would you like to do?'
    inventory_option = choose_array_option(inventory_options, true)
    # puts "1) Check Status\n2) Equip Items\n3) Use Potions\n4) Sell Items"
    # print "To select an option, enter the number that corresponds with the option you want: "
    # inventory_option = gets.chomp.to_i
    case inventory_option
    when 1 then display_full_hero_status
    when 2 then equip_items
    when 3 then use_potions
    when 4 then sell_items
    else error 'check_inventory() -> Error! Invalid Option!'
    end
  end

  # TODO: Add a way to unequip items and equip more than one item
  def equip_items
    if current_inventory_weapons.empty? && current_inventory_armor.empty?
      puts 'You have nothing to equip!'
      return
    end
    print "What would you like to equip?\n1) Weapons\n2) Armor "
    equip_choice = gets.chomp.to_i
    case equip_choice
    when 1
      unless items_exist? current_inventory_weapons
        puts 'You have no weapons to equip!'
        return
      end
      display_inventory_weapons
      # TODO: Refactor this into choose_array_option
      print 'To select a weapon to equip, enter the number that corresponds with the weapon you want: '
      weapon_option = gets.chomp.to_i
      item = current_inventory_weapons.values_at(weapon_option.pred).first || nil
      if validate_num(weapon_option, weapon_count) && !item.nil?
        equip(item)
      else
        error 'equip_items() -> Error! Unable to equip weapon!'
      end
    when 2
      unless items_exist? current_inventory_armor
        puts 'You have no armor to equip!'
        return
      end
      display_inventory_armor
      # TODO: Refactor this into choose_array_option
      print 'To select an armor to equip, enter the number that corresponds with the armor you want: '
      armor_option = gets.chomp.to_i
      item = current_inventory_armor.values_at(armor_option.pred).first || nil
      if validate_num(armor_option, armor_count) && !item.nil?
        equip(item)
      else
        error 'equip_items() -> Error! Unable to equip armor!'
      end
    else error 'equip_items() -> Error! Invalid Option!' # TODO: change to __method__ in each error
    end
  end

  def display_full_hero_status
    display_stats
    display_inventory_items
    display_equipped_items
  end

  # FIXME: used self here so it can call the method instead of the instance var directly,
  # just in case we have any validation in those methods
  def display_stats
    # TODO: Display the heros name and class as well here with a nice header like ~~~~
    puts "\nBase class: #{@base_class}"
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
