

$debug = false

module Formulas
  def random_treasures(index)
    rand(0..(index*1.5-1)).to_i
  end
  def random_monsters(index)
    rand(1..(index + index/2 + 1)).to_i
  end
  def m_health(index)
    rand(100..100 + rand(index*2-2..index*2+1))
  end
  def m_level(index)
    rand(index..index**2+1)
  end
  def m_attack(index)
    rand(index+30..30+index**3/2).to_i
  end
  def m_defense(index)
    rand(index+15..15+index**4/2).to_i
  end
  def m_experience(index)
    rand(index*8..index*8+index**4 +3 /2).to_i
  end
  def m_money(index)
    rand(index+120..120+index**2*index+1)
  end
end

module Procs
  DISPLAY = Proc.new { |item, index| puts "#{index.next}) #{item.to_s}" }
  DISPLAY_WEAPON_WITH_STATUS = Proc.new { |weapon, index| puts "#{index.next}) #{sprintf("%-12s", weapon)} Damage: #{sprintf("%-8d", weapon.damage)} Price: #{sprintf("%-8d", weapon.price)} Sell_Value: #{sprintf("%-8d", weapon.sell_value)} Description: #{weapon.description}" }
  DISPLAY_ARMOR_WITH_STATUS  = Proc.new { |armor,  index| puts "#{index.next}) #{sprintf("%-12s", armor)} Defense: #{sprintf("%-8d", armor.defense)} Price: #{sprintf("%-8d", armor.price)} Sell_Value: #{sprintf("%-8d", armor.sell_value)} Description: #{armor.description}" }
  DISPLAY_POTION_WITH_STATUS = Proc.new { |potion, index| puts "#{index.next}) #{sprintf("%-12s", potion)} Health: #{sprintf("%-8d", potion.health)} Price: #{sprintf("%-8d", potion.price)} Sell_Value: #{sprintf("%-8d", potion.sell_value)} Description: #{potion.description}" }
end

module SoldierWeaponAttributes

  BASE_EFFECT = 12
  BASE_PRICE = 100
  BASE_SELL_VALUE = 50

  EFFECT_OFFSET = 12
  PRICE_OFFSET = 110
  SELL_VALUE_OFFSET = 65
end

module MageWeaponAttributes

  BASE_EFFECT = 10
  BASE_PRICE = 92
  BASE_SELL_VALUE = 64

  EFFECT_OFFSET = 8
  PRICE_OFFSET = 130
  SELL_VALUE_OFFSET = 50
end

module RangedWeaponAttributes

  BASE_EFFECT = 14
  BASE_PRICE = 134
  BASE_SELL_VALUE = 86

  EFFECT_OFFSET = 7
  PRICE_OFFSET = 150
  SELL_VALUE_OFFSET = 60
end

module SoldierArmorAttributes
  BASE_EFFECT = 12
  BASE_PRICE = 100
  BASE_SELL_VALUE = 50

  EFFECT_OFFSET = 12
  PRICE_OFFSET = 110
  SELL_VALUE_OFFSET = 65
end

module MageArmorAttributes
  BASE_EFFECT = 10
  BASE_PRICE = 92
  BASE_SELL_VALUE = 64

  EFFECT_OFFSET = 8
  PRICE_OFFSET = 130
  SELL_VALUE_OFFSET = 50
end

module RangedArmorAttributes
  BASE_EFFECT = 14
  BASE_PRICE = 134
  BASE_SELL_VALUE = 86

  EFFECT_OFFSET = 7
  PRICE_OFFSET = 150
  SELL_VALUE_OFFSET = 60
end

module PotionAttributes
  BASE_EFFECT = 10
  BASE_PRICE = 60
  BASE_SELL_VALUE = 35

  EFFECT_OFFSET = 12
  PRICE_OFFSET = 220
  SELL_VALUE_OFFSET = 80
end

#TODO
#Create attribute modules for the armor classes and the potions
#also create different types of soldiers and mages and stuff - take it from the javascript game

def error(item="answer")
  puts "Invalid #{item}!"
end

# monster = Monster.new(100,1,100, 20,100, 25)
# hero = Hero.new(100, 1, 25, 40)
# #hero.customize
# #hero.game_options

if $debug then puts monster.inspect end
if $debug then puts hero.inspect end

#arondight = Weapon.new("Arondight",50, 100, 50)
#valkyrie = Armor.new("Valkyrie", 30, 60, 30)
#elixir = Potion.new("Elixir", 100, 99, 60)

if $debug then puts arondight.inspect end
if $debug then puts valkyrie.inspect end
if $debug then puts elixir.inspect end

#hero.add_to_inventory(arondight)
if $debug then puts hero.inventory.inspect end

if $debug
  shop = Shop.new
  shop.soldier_weapons.each do |weapon|
    puts weapon.name
  end
end

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

# d = Dungeon.new(2)
# p d

# weaponshop = SoldierWeaponShop.new
# weaponshop.display_weapons
#
# s1 = MageWeaponShop.new
# s1.display_weapons
#
# s2 = ArcherWeaponShop.new
# s2.display_weapons
#puts weaponshop.inspect
