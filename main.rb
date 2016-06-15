#!/usr/bin/env ruby
# require "pry"
# Require all files
Dir[File.join(File.dirname(__FILE__), 'lib', 'character', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', 'dungeon', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', 'shop' ,'**', '*.rb')].each { |file| require file }

# binding.pry
# Set the debug flag to make output more verbose
$debug = true

monster = Monster.new(
  health: 100,
  level: 1,
  attack: 100,
  defense: 20,
  money: 100,
  exp: 25
)

hero = Hero.new(
  health: 100,
  level: 1,
  attack: 25,
  defense: 40,
  money: 210000, #TODO Change this to a very small number for release. It's only this high for debug reasons
  exp: 0
)

puts "Welcome! Let's get you comfy! Create your custom character!"
hero.customize

shop = Shop.new

def battle_monster(hero)
  case hero.dungeon_level
    when 1..3
      puts "Level 1-3"
     # battle
    when 4..6
      puts "Level 4-6"
    when 7..10
      puts "Level 7-10"
    else
      error
  end
end

loop do
  puts "\nEnter 'd' to enter dungeon, 's' to shop, 'i' for inventory, 'o' for options menu, or 'q' to exit game "
  option = gets.chomp.downcase
  case option
  when 'q' then break
  when 'd' then Dungeon.enter(hero)
  when 's' then shop.goto_shop(hero)
  when 'i' then hero.check_inventory
  when 'o' then hero.game_options
  else error
  end
end
puts "Goodbye!"

# loop do
#   puts "\nEnter 'r' to roll, 's' to shop, 'i' for inventory, 'o' for options menu, or 'q' to exit game "
#   option = gets.chomp.downcase
#   case option
#     when 'q'
#       break
#     when 'r'
#       random_dice1 = rand(1..6)
#       random_dice2 = rand(1..6)
#       total = random_dice1 + random_dice2
#       puts "You rolled a #{random_dice1} and a #{random_dice2} for a total of #{total}!"
#       puts total.even? ? battle_monster(hero) : "Missed!"
#     when 's'
#       shop.goto_shop(hero)
#     when 'i'
#       hero.check_inventory
#     when 'o'
#       hero.game_options
#     else
#       error
#   end
# end
# puts "Goodbye!"
