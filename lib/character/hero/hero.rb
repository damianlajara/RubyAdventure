require_relative "../character"
require_relative "../../helpers/customize"
require_relative "../../helpers/inventory"
require_relative "../../helpers/equip"

class Hero < Character
  include Customize
  include Inventory
  include Equip

  attr_accessor :max_hp, :current_dungeon
  attr_reader :inventory, :dungeon_level
  def initialize(hero_args = {})
    super(hero_args) # make sure to initialize stuff abstracted into the character class
    @max_hp = 100
    @gender = 'genderless'
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
    @skip_battle_scenes = false
    @dungeon_level = 1
    @current_dungeon = nil
    @dungeons_conquered = [Dungeon.new('mountain', 3), Dungeon.new('underworld', 1), Dungeon.new('forest', 2)] #TODO Remove this dummy data. For debugging purposes
  end

  def loot(monster)
    @money += monster.reward_money
    @experience += monster.reward_experience
  end

  def dungeons_conquered
    @dungeons_conquered.sort_by { |dungeon| dungeon.level }
  end

  def conquer_dungeon(dungeon)
    @dungeons_conquered.push(dungeon)
    reset_current_dungeon
    @dungeon_level += 1
    puts "Congratulations! You succesfully completed dungeon level #{dungeon.level}"
    # TODO Display a summary(statistics) of mosters killed and items collected from that dungeon
  end

  def steps_walked
    @current_dungeon.steps_explored || 0
  end

  def walk(amount_of_steps)
    @current_dungeon.steps_explored = amount_of_steps
  end

  def reset_current_dungeon
    @current_dungeon = nil
  end

  def level_up(exp)
    case exp
    when 0..50
      self.level += 1
    end
  end

  def experience=(exp)
    @experience = exp
    level_up(exp)
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

  # TODO Add a way to unequip items and equip more than one item
  def equip_items
    if current_inventory_weapons.empty? && current_inventory_armor.empty?
      puts "You have nothing to equip!"
      return
    end
    print "What would you like to equip?\n1) Weapons\n2) Armor "
    equip_choice = gets.chomp.to_i
    case equip_choice
    when 1
      unless items_exist? current_inventory_weapons
        puts "You have no weapons to equip!"
        return
      end
      display_inventory_weapons
      #TODO Refactor this into choose_array_option
      print "To select a weapon to equip, enter the number that corresponds with the weapon you want: "
      weapon_option = gets.chomp.to_i
      item = (current_inventory_weapons.values_at(weapon_option.pred).first) || nil
      if validate_num(weapon_option, weapon_count) && !item.nil?
        self.equip(item)
      else
        error "equip_items() -> Error! Unable to equip weapon!"
      end
    when 2
      unless items_exist? current_inventory_armor
        puts "You have no armor to equip!"
        return
      end
      display_inventory_armor
      #TODO Refactor this into choose_array_option
      print "To select an armor to equip, enter the number that corresponds with the armor you want: "
      armor_option = gets.chomp.to_i
      item = (current_inventory_armor.values_at(armor_option.pred).first) || nil
      if validate_num(armor_option, armor_count) && !item.nil?
        self.equip(item)
      else
        error "equip_items() -> Error! Unable to equip armor!"
      end
    else error "equip_items() -> Error! Invalid Option!" #TODO change to __method__ in each error
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

end #end class
