#!/usr/bin/env ruby
require 'ruby-progressbar'
# Require all files
Dir[File.join(File.dirname(__FILE__), 'lib', 'character', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', 'dungeon', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', 'shop' ,'**', '*.rb')].each { |file| require file }
require File.join(File.dirname(__FILE__), 'lib', 'helpers', 'formulas.rb')

# Set the debug flag to make output more verbose
$debug = true

hero = Hero.new(
  health: 100,
  level: 1,
  attack: 25,
  defense: 40,
  money: 210000, #TODO Change this to a very small number for release. It's only this high for debug reasons
  exp: 0
)

include Formulas

puts "Welcome! Let's get you comfy! Create your custom character!"
hero.customize

shop = Shop.new

$pr_logger = ProgressBar.create(length: 0, format: "") # For testing purposes. Make sure to remove

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

def steps(roll)
  if roll[:double]
    # TODO get hint here
    puts "Nice, you rolled a double #{roll[:die1]}!"
  end
  random_steps(roll)
end

def roll_dice(hero, roll)
  dungeon = hero.current_dungeon
  if roll[:total].even?
    steps = steps(roll)
    hero.walk(steps)
    puts "Nice it's even. You took #{steps} steps"
    if hero.steps_walked >= dungeon.total_steps
      # TODO Find a way to battle the boss of that level before conquering dungeon
      puts "Congratulations! You have succesfully explored the whole dungeon!"
      puts "However, you have awoken the beast with your victory cry! Prepare for battle!"
      # battle_dungeon_boss(hero)
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
    puts "You have no conqeuered any dungeons..yet! Go get em'!"
  end
end

def check_progress(hero)
  # binding.pry
  $pr_logger.log "In here you can check your progress thorughout the dungeon. Steps walked. Steps left. \nTreasures found. Total treasures in dungeon. Hints available. Hints until next key. \nAnd how many keys you currently possess."
  ProgressBar.create(title: "Hints", total: 3, length: 85, format: "%t: |%B| %c/%C Hints Found (%P%%)")
  ProgressBar.create(title: "Steps", starting_at: hero.steps_walked, total: hero.current_dungeon.total_steps, length: 85, format: "%t: |%B| %c/%C Steps Walked (%P%%)")
  ProgressBar.create(title: "Treasures", total: hero.current_dungeon.total_treasure_chests, length: 85, format: "%t: |%B| %c/%C Treasures Found (%P%%)")
end

def check_stats(hero)
  gold_found = hero.current_dungeon.monsters_killed.map { |monster| monster.reward_money }.reduce(:+)
  total_gold = hero.current_dungeon.monsters.map { |monster| monster.reward_money }.reduce(:+)
  exp_gained = hero.current_dungeon.monsters_killed.map { |monster| monster.reward_experience }.reduce(:+)
  total_exp = hero.current_dungeon.monsters.map { |monster| monster.reward_experience }.reduce(:+)

  puts "In here you can check your stats. Monsters defeated. Amount of items used. Bonus of current weapon and armor. money and exp gained so far as well as basic info like health."
  hero.display_stats

  ProgressBar.create(title: "Monsters killed", starting_at: hero.current_dungeon.monsters_killed.count, total: hero.current_dungeon.number_of_monsters, length: 85, format: "%t: |%B| %c/%C Monsters Killed (%P%%)")
  ProgressBar.create(title: "Experience", starting_at: exp_gained, total: total_exp, length: 85, format: "%t: |%B| %c/%C Total Exp Gained (%P%%)")
  ProgressBar.create(title: "Gold", starting_at: gold_found, total: total_gold, length: 85, format: "%t: |%B| %c/%C Total Gold Found (%P%%)")
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
def enter_dungeon(hero)
  Dungeon.enter(hero)
  loop do
    $pr_logger.log "\nEnter 'r' to roll dice, 'l' to change level, 'p' to check progress, 's' to check stats, or 'q' to leave the dungeon"
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
  puts "\nEnter 'd' to enter dungeon, 's' to shop, 'i' for inventory, 'o' for options menu, or 'q' to exit game "
  option = gets.chomp.downcase
  case option
  when 'd' then enter_dungeon(hero)
  when 's' then shop.goto_shop(hero)
  when 'i' then hero.check_inventory
  when 'o' then hero.game_options
  else break
  end
end
puts "Goodbye!"
