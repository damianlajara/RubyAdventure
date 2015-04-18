require './items.rb'
require './rpg.rb'
require './shops.rb'
require './characters.rb'
require './dungeon.rb'

monster = Monster.new(100,1,100, 20,100, 25)
hero = Hero.new(100, 1, 25, 40)

puts "Welcome! Let's get you comfy! Create your custom character!"
hero.customize
hero.game_options

shop = Shop.new()
p shop

loop do
  puts "Enter 'r' to roll, 's' to shop, 'i' for inventory, 'o' for options menu, or 'q' to exit game "
  option = gets.chomp.downcase
  case option
    when 'q'
      break
    when 'r'
      random = rand(1..6)
      puts "You rolled a #{random}!"
      puts random.even? ? battle_monster(hero) : "Missed!"
    when 'i'
      hero.check_inventory
    when 'o'
      hero.game_options
    else
      error
  end
end
