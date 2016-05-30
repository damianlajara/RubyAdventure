def display_hash_option(hash, saying = '')
  print saying
  hash.each_with_index { |(key, _value), index| print "#{index.next}) #{key} " }
end

def display_array_value_with_index(array)
  array.each_with_index { |value, index| puts "#{index.next}) #{value}" }
end

def choose_array_option(classes_array)
  display_array_value_with_index(classes_array)
  print "To choose a specification, enter the number that corresponds with the class you want: "
  choice = gets.chomp.to_i
  classes_array[choice.pred]
end

module Procs
  DISPLAY = Proc.new { |item, index| puts "#{index.next}) #{item.to_s}" }
  DISPLAY_WEAPON_WITH_STATUS = Proc.new { |weapon, index| puts "#{index.next}) #{sprintf("%-16s", weapon)} Damage: #{sprintf("%-8d", weapon.damage)} Price: #{sprintf("%-8d", weapon.price)} Sell_Value: #{sprintf("%-8d", weapon.sell_value)} Description: #{weapon.description}" }
  DISPLAY_ARMOR_WITH_STATUS  = Proc.new { |armor,  index| puts "#{index.next}) #{sprintf("%-16s", armor)} Defense: #{sprintf("%-7d", armor.defense)} Price: #{sprintf("%-8d", armor.price)} Sell_Value: #{sprintf("%-8d", armor.sell_value)} Description: #{armor.description}" }
  DISPLAY_POTION_WITH_STATUS = Proc.new { |potion, index| puts "#{index.next}) #{sprintf("%-16s", potion)} Health: #{sprintf("%-8d", potion.health)} Price: #{sprintf("%-8d", potion.price)} Sell_Value: #{sprintf("%-8d", potion.sell_value)} Description: #{potion.description}" }
end


def error(item="answer")
  puts "Invalid #{item}!"
  return
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

# s1 = MageWeaponShop.new
# s1.display_weapons

# s2 = ArcherWeaponShop.new
# s2.display_weapons
#puts weaponshop.inspect
