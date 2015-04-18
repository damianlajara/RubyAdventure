class Character
  attr_accessor :attack, :defense, :hp, :max_hp, :level, :money, :experience
  attr_reader :name, :class, :gender

  def display_hash_option(hash, saying="")
    print saying
    hash.each_with_index { |(key, value), index| print "#{index.next}) #{key} "}
  end

  def display_array(array)
    array.each_with_index { |value, index| puts "#{index.next}) #{value}"}
  end

  def choose_array_option(classes_array)
    display_array classes_array
    choice = gets.chomp.to_i
    classes_array[choice.pred]
  end

  #TODO maybe make these into class variables

  @@classes = {
    :soldier => %w(Barbarian Knight Paladin Samurai),
    :mage => %w(Necromancer Wizard Illusionist Alcheemist),
    :archer => %w(Elf Gunner Tamer Poet)
  }
  p @@classes

  CLASS = %w(Soldier Mage Archer)
  #GENDER = %w(Male Female)
  GENDER = { male: "Male", female: "Female" }

  def initialize(health, lvl, att, defense, money, exp)
    @health = health
    @level = lvl
    @attack = att
    @defense = defense
    @money = money
    @experience = exp
  end

  def customize_name
    print "What would you like your character to be called? "
    @name = gets.chomp.capitalize
  end

  def customize_gender
    display_hash_option GENDER, "What is your gender? "
    choice = gets.chomp.to_i
    @gender =
      case choice
      when 1
        GENDER[:male]
      when 2
        GENDER[:female]
      when 3
        print "Enter your preferred gender: "
        gets.chomp.downcase
      else
        error
      end
  end

  def customize_class
    display_hash_option @@classes, "What class would you like to choose your character from? "
    #print "What class would you like to choose your character from? 1) #{CLASS[0]} 2) #{CLASS[1]} 3) #{CLASS[2]} "
    choice = gets.chomp.to_i
    @class =
      case choice
      when 1
        choose_array_option @@classes[:soldier]
        #@@classes.
      when 2
        choose_array_option @@classes[:mage]
      when 3
        choose_array_option @@classes[:archer]
      else
        error
      end
  end
  def game_options
    puts "#{"*" * 4} Game Options #{"*" * 4}\n"
    puts "1) Toggle Battle Scenes"
    puts "2) Change Class"
    puts "3) Change Gender"
    puts "4) Change Name"
    puts "5) Exit"
    option = gets.chomp.to_i
    case option
      when 1
        puts "Do you want to disable all of the battle scenes? 1) Yes 2) No"
        scene_option = gets.chomp.to_i
        case scene_option
          when 1
            skip = true
            puts "Battle scenes have been disabled."
          when 2
            skip = false
            puts "Battle scenes have been enabled."
          else
            error
        end
      when 2
        puts "Are you sure you want to change your class?\n";
        puts "You will lose all of your current weapons and armor!\n";
        puts "1) Yes 2) No "
        class_choice = gets.chomp.to_i
        case class_choice
          when 1
            customize_class
            puts "Congratulations! You're class has changed to #{@class}!"
          when 2
            puts "Good! I thought the #{@class} was better anyway."
          else
            error
        end
      when 3
        puts "Are you sure you want to change your gender?"
        puts "1) Yes 2) No "
        gender_choice = gets.chomp.to_i
        case gender_choice
          when 1
            customize_gender
            puts "Congratulations! You're gender has changed to #{@gender}!"
          when 2
            puts "Hmmm...I guess it was hard converting to something your not."
          else
            error
        end
      when 4
        puts "Are you sure you want to change your name?"
        puts "1) Yes 2) No "
        name_choice = gets.chomp.to_i
        case name_choice
          when 1
            customize_name
            puts "Congratulations! You're name has changed to #{@name}!"
          when 2
            puts "Awww man...I was looking forward to see the weird name you were going to choose!"
          else
            error
        end
      when 5
        puts "Exiting options menu..."
      else
        error
    end
  end

  def check_inventory
    puts "Inside inventory! Let's see what you got!"
  end

  def print_welcome_message
    if @gender.index(/[aeiou]/) == 0
      puts "Hello #{@name}, I see you are an #{@gender} with a class of #{@class}!"
    else
      puts "Hello #{@name}, I see you are a #{@gender} with a class of #{@class}!"
    end
  end

  def customize
    customize_name
    customize_gender
    customize_class
    print_welcome_message
  end

end

class Hero < Character
  attr_reader :inventory, :dungeon_level

  def initialize(health, lvl, att, defense, money = 0, exp = 0)
    super
    @max_hp = 100
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end

  def exp=experience
    @experience = experience
    case experience
      when 0..50
        self.level +=1
    end
  end

  def add_to_inventory(item)
    if item.class == Weapon
      #check weapon to see if hero class can use it
      @inventory[:current_weapons].push(item)
    elsif item.class == Armor
      #check armor
      @inventory[:current_armor].push(item)
    elsif item.class == Potion
      @inventory[:current_potions].push(item)
    else
      error("item inside add_to_inventory()")
    end
  end

end

#Soldier CLASS
class Barbarian < Hero
  #super
end

class Knight < Hero
end

class Paladin < Hero
end

class Samurai < Hero
end


#Mage CLASS
class Necromancer < Hero
end

class Wizard < Hero
end

class Illusionist < Hero
end

class Alchemist < Hero
end


#Archer CLASS (projectiles)

class Elf < Hero
end

class Gunner < Hero
end

class Tamer  < Hero# uses pets to attack
end

class Poet < Hero
end





class Monster < Character

  def initialize(health, lvl, att, defense, money, exp)
    super
  end

end

class Wolf < Monster
  def initialize

  end
end

class Golem < Monster
  def initialize

  end
end

class FleshHunter < Monster
  def initialize

  end
end

class BoneReaver < Monster
  def initialize

  end
end

class MageLord < Monster
  def initialize

  end
end

class Executioner < Monster
  def initialize

  end
end

class DarkVessel < Monster
  def initialize

  end
end

class TorturedSoul < Monster
  def initialize

  end
end

class DarkCultist < Monster
  def initialize

  end
end
