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
hero.customize

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
      Shop.new.goto_shop(hero)
    when 'i'
      hero.check_inventory
    when 'o'
      hero.game_options
    else
      error
  end
end
