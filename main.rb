require './items.rb'
require './mods.rb'
require './shops.rb'
require './characters.rb'
require './dungeon.rb'

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
  money: 0,
  exp: 0
)

puts "Welcome! Let's get you comfy! Create your custom character!"
#hero.customize

shop1 = SoldierWeaponShop.new()
p shop1

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
