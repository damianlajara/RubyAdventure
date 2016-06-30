#!/usr/bin/env ruby
require 'ruby-progressbar'
require "pry"

# Monkey Patch Classes
Dir[File.join(File.dirname(__FILE__), 'lib', 'core_extensions', '**', '*.rb')].each { |file| require file }
String.include CoreExtensions::String# TODO: Maybe Change to refinements?

# Require all files
Dir[File.join(File.dirname(__FILE__), 'lib', 'character', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', 'dungeon', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', 'shop' ,'**', '*.rb')].each { |file| require file }
# require File.join(File.dirname(__FILE__), 'lib', 'helpers', 'formulas.rb')

include Display # DEBUG - using it for choose_array_option. Remove after refactoring
include Formulas # DEBUG - using it for random_steps. Remove after refactoring

# Set the debug flag to make output more verbose
$debug = true

# Start the game! # TODO: Refactor into another class/module/file
puts "\nWelcome! Let's create your custom character!"
hero = Hero.create
hero.customize

shop = Shop.new

def roll
  random_dice1 = rand(1..6)
  random_dice2 = rand(1..6)
  total = random_dice1 + random_dice2
  puts "You rolled a #{random_dice1} and a #{random_dice2} for a total of #{total}!"
  {
    die1: random_dice1,
    die2: random_dice2,
    total: total,
    double: random_dice1 == random_dice2
  }
end

def steps(hero, roll)
  if roll[:double]
    puts "Nice, you rolled a double #{roll[:die1]}!"
    hero.unlock_secret_hint
  end
  random_steps(roll)
end

# Once you conquery the dungeon, you have already explored the whole dungeon,
# so the steps explored shouldn't increase and
# you should'nt be able to battle the boss anymore since he's defeated.
# You can, however, still get hints and defeat monsters in order to level up
def roll_dice(hero, roll)
  dungeon = hero.current_dungeon
  if roll[:total].even?
    steps = steps(hero, roll)
    puts "You took #{steps} steps"
    unless hero.conquered_dungeon?
      hero.walk(steps) unless hero.dungeon_explored?
      if hero.steps_walked >= dungeon.total_steps
        puts "Congratulations! You have succesfully explored the whole dungeon!"
        puts "However, you have awoken the beast with your victory cry! Prepare for battle!"
        dungeon.battle_boss(hero)
      end
    end
  else
    dungeon.battle(hero)
  end
end

def change_level(hero)
  if hero.dungeons_conquered.any?
    puts "What dungeon level would you like to visit?"
    # TODO add validation for option
    option = choose_array_option hero.dungeons_conquered.map { |dungeon| "Dungeon level #{dungeon.level}" }, true
    hero.current_dungeon = hero.dungeons_conquered[option.pred]
    Dungeon.enter(hero)
  else
    puts "You have not conqeuered any dungeons..yet! Go get em'!"
  end
end

def check_progress(hero)
  print "\n"
  ProgressBar.create(title: "Hints", starting_at: hero.hints ,total: Hero::MAX_HINTS, length: 85, format: "%t: |%B| %c/%C Hints Found (%P%%)").stop
  # TODO implement the treasure chest functionality
  ProgressBar.create(title: "Treasures", starting_at: hero.treasures_found, total: hero.current_dungeon.total_treasure_chests, length: 85, format: "%t: |%B| %c/%C Treasures Found (%P%%)").stop
  ProgressBar.create(title: "Steps", starting_at: hero.steps_walked, total: hero.current_dungeon.total_steps, length: 85, format: "%t: |%B| %c/%C Steps Walked (%P%%)").stop
  puts "Keys Obtained: #{hero.keys.count}"
end

def check_stats(hero)
  gold_found = hero.current_dungeon.monsters_killed.map { |monster| monster.reward_money }.reduce(0, :+)
  total_gold = hero.current_dungeon.total_monster_rewards[:money]
  exp_gained = hero.current_dungeon.monsters_killed.map { |monster| monster.reward_experience }.reduce(0, :+)
  total_exp = hero.current_dungeon.total_monster_rewards[:experience]

  hero.display_stats
  puts "Weapon Bonus: + #{hero.weapon_bonus} damage"
  puts "Armor bonus: + #{hero.armor_bonus} defense"
  ProgressBar.create(title: "Gold", starting_at: gold_found, total: total_gold, length: 85, format: "%t: |%B| %c/%C Total Gold Found (%P%%)").stop
  ProgressBar.create(title: "Experience", starting_at: exp_gained, total: total_exp, length: 85, format: "%t: |%B| %c/%C Total Exp Gained (%P%%)").stop
  ProgressBar.create(title: "Monsters killed", starting_at: hero.current_dungeon.monsters_killed.count, total: hero.current_dungeon.number_of_monsters, length: 85, format: "%t: |%B| %c/%C Monsters Killed (%P%%)").stop
end

def reset_character(hero)
  hero = hero.create_new_hero
  puts "Congratulations! You're class has changed to #{hero.main_class}!"
  hero
end

# Dungeon ideas:
# roll dice. If even, walk a rand number of steps depending on the num u rolled
# if odd, you battle a random monster from that level
# If you roll a double you will get a hint. if you collect all 3 hints, you will
# get a key (bronze, silver, or gold - decided at random as well as by the rarity)
# You can then use the key to unlock various treasures laying around in the dungeon
# The treasures rareness will be decided by a formula
# There can be multiple treasure chests in a dungeon
# Every dungeon also has a specified number of steps. Once you clear all the steps you conquer the dungeon.
# And can move on to the next level.
# TODO make a way where the user can choose what level to go to. For instace, if he conquered dungeon levels 1-4,
# He should be able to choose what level he wants to go to from those four.
# You can take advantage of this by battling weak enemies in order to level up.
# While in the dungeon the user can choose to roll, check level, check progress((user_steps/dungeon_total_steps)*100),
# check how many monsters defeated, treasures collected and hints left until the next key
# He can also choose to exit and go back to the main menu where you can resupply and visit the shop
# Every level has a boss that you can find at the entrance to the next dungeon level. (a.k.a completed all the steps)
# You must defeat him in order to truly conquer that level in the dungeon
# The user wins when he has conquered all levels in the dungeon
# Make a way to save progress in the game with textfiles. Or turn it into a webapp with a database
# add abilities. Also add mana to every hero class, since the abilities depend on mana consumption
# add attributes such as dodge/evade, chance of hits, luck and mobility to make use or ranged classes and stuff for strategic play
def enter_dungeon(hero)
  Dungeon.enter(hero)
  loop do
    print "\nEnter 'r' to roll dice, 'l' to change level, 's' to check stats, 'p' to check progress, or 'q' to leave the dungeon: "
    option = gets.chomp.downcase
    case option
    when 'r' then roll_dice(hero, roll)
    when 'l' then change_level(hero)
    when 'p' then check_progress(hero)
    when 's' then check_stats(hero)
    else break
    end
  end
end

loop do
  print "\nEnter 'd' to enter dungeon, 's' to shop, 'i' for inventory, 'o' for options menu, 'c' to change hero(new class), or 'q' to exit game: "
  option = gets.chomp.downcase
  puts "\n"
  case option
  when 'd' then enter_dungeon(hero)
  when 's' then shop.goto_shop(hero)
  when 'i' then hero.check_inventory
  when 'o' then hero.game_options
  when 'c' then hero = reset_character(hero)
  else break
  end
end

#TODO save progress on exit
puts "Thanks for playing Ruby Adventure!!"
