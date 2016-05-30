#!/usr/bin/env ruby

# Require all files
Dir[File.join(File.dirname(__FILE__), '**', '*.rb')].each { |file| require file }

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
#shop1 = SoldierWeaponShop.new()
#p shop1

loop do
  puts "\nEnter 'r' to roll, 's' to shop, 'i' for inventory, 'o' for options menu, or 'q' to exit game "
  option = gets.chomp.downcase
  case option
    when 'q'
      break
    when 'r'
      random_dice1 = rand(1..6)
      random_dice2 = rand(1..6)
      total = random_dice1 + random_dice2
      puts "You rolled a #{random_dice1} and a #{random_dice2} for a total of #{total}!"
      puts total.even? ? battle_monster(hero) : "Missed!"
    when 's'
      shop.goto_shop(hero)
    when 'i'
      hero.check_inventory
    when 'o'
      hero.game_options
    else
      error
  end
end
puts "Goodbye!"
