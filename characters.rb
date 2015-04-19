def display_hash_option(hash, saying = '')
  print saying
  hash.each_with_index { |(key, _value), index| print "#{index.next}) #{key} " }
end

def display_array_value_with_index(array)
  array.each_with_index { |value, index| puts "#{index.next}) #{value}" }
end

def choose_array_option(classes_array)
  display_array_value_with_index classes_array
  choice = gets.chomp.to_i
  classes_array[choice.pred]
end

class Character
  attr_accessor :attack, :defense, :hp, :max_hp, :level, :money, :experience
  attr_reader :name, :class, :gender

  CLASSES = {
    soldier: %w(Barbarian Knight Paladin Samurai),
    mage: %w(Necromancer Wizard Illusionist Alcheemist),
    ranged: %w(Archer Gunner Tamer Elf)
  }

  GENDER = { male: 'Male', female: 'Female' }

  # def initialize(health, lvl, att, defense, money, exp)
  #   @health = health
  #   @level = lvl
  #   @attack = att
  #   @defense = defense
  #   @money = money
  #   @experience = exp
  # end

  def initialize(hero_args = {})
    @health = hero_args[:health] || 100
    @level = hero_args[:level] || 1
    @attack = hero_args[:attack] || 0
    @defense = hero_args[:defense] || 0
    @money = hero_args[:money] || 0
    @experience = hero_args[:exp] || 0
  end

  def customize_name
    print 'What would you like your character to be called? '
    @name = gets.chomp.capitalize
  end

  def customize_gender
    display_hash_option GENDER, 'What is your gender? '
    choice = gets.chomp.to_i
    @gender =
      case choice
      when 1
        GENDER[:male]
      when 2
        GENDER[:female]
      when 3
        print 'Enter your preferred gender: '
        gets.chomp.downcase
      else
        error 'Character -> customize_gender()'
      end
  end

  def customize_class
    display_hash_option CLASSES, 'What class would you like to choose your character from? '
    choice = gets.chomp.to_i
    @class =
      case choice
      when 1 then choose_array_option CLASSES[:soldier]
      when 2 then choose_array_option CLASSES[:mage]
      when 3 then choose_array_option CLASSES[:ranged]
      else error 'customize_class() -> case statement'
      end
  end

  def game_options
    puts "\n#{'*' * 4} Game Options #{'*' * 4}\n"
    puts '1) Toggle Battle Scenes'
    puts '2) Change Class'
    puts '3) Change Gender'
    puts '4) Change Name'
    puts '5) Exit'
    option = gets.chomp.to_i
    case option
    when 1
      puts 'Do you want to disable all of the battle scenes? 1) Yes 2) No'
      scene_option = gets.chomp.to_i
      case scene_option
      when 1
        @skip = true
        puts 'Battle scenes have been disabled.'
      when 2
        @skip = false
        puts 'Battle scenes have been enabled.'
      else
        error 'game_options -> first case when 1 -> second case'
      end
    when 2
      puts "Are you sure you want to change your class?\n"
      puts "You will lose all of your current weapons and armor!\n"
      puts '1) Yes 2) No '
      class_choice = gets.chomp.to_i
      case class_choice
      when 1
        customize_class
        puts "Congratulations! You're class has changed to #{@class}!"
      when 2
        puts "Good! I thought the #{@class} was better anyway."
      else
        error 'game_options -> first case when 2 -> second case'
      end
    when 3
      puts 'Are you sure you want to change your gender?'
      puts '1) Yes 2) No '
      gender_choice = gets.chomp.to_i
      case gender_choice
      when 1
        customize_gender
        puts "Congratulations! You're gender has changed to #{@gender}!"
      when 2
        puts 'Hmmm...I guess it was hard converting to something your not.'
      else
        error 'game_options -> first case when 3 -> second case'
      end
    when 4
      puts 'Are you sure you want to change your name?'
      puts '1) Yes 2) No '
      name_choice = gets.chomp.to_i
      case name_choice
      when 1
        customize_name
        puts "Congratulations! You're name has changed to #{@name}!"
      when 2
        puts 'Awww man...I was looking forward to see the weird name you were going to choose!'
      else
        error 'game_options -> first case when 4 -> second case'
      end
    when 5
      puts 'Exiting options menu...'
    else
      error 'game_options -> first case when 5'
    end
  end

  def check_inventory
    puts 'Inside inventory! Let\'s see what you got!'
  end

  def print_welcome_message
    if @gender.index(/[aeiou]/) == 0
      puts "Welcome #{@name}! I see you are an #{@gender}, with a class of #{@class}!"
    else
      puts "Welcome #{@name}! I see you are a #{@gender}, with a class of #{@class}!"
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

  def initialize(hero_args = {})
    super
    @max_hp = 100
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end

  def exp=(experience)
    @experience = experience
    case experience
    when 0..50
      self.level += 1
    end
  end

  def add_to_inventory(item)
    if item.class == Weapon
      # check weapon to see if hero class can use it
      @inventory[:current_weapons].push(item)
    elsif item.class == Armor
      # check armor
      @inventory[:current_armor].push(item)
    elsif item.class == Potion
      @inventory[:current_potions].push(item)
    else
      error 'add_to_inventory() -> item'
    end
  end

end

# Soldier Class
class Barbarian < Hero
  def initialize
  end
end

class Knight < Hero
  def initialize
  end
end

class Paladin < Hero
  def initialize
  end
end

class Samurai < Hero
  def initialize
  end
end

# Mage Class
class Necromancer < Hero
  def initialize
  end
end

class Wizard < Hero
  def initialize
  end
end

class Illusionist < Hero
  def initialize
  end
end

class Alchemist < Hero
  def initialize
  end
end

# Ranged Class
class Archer < Hero
  def initialize
  end
end

class Gunner < Hero
  def initialize
  end
end

class Tamer  < Hero # uses pets to attack
  def initialize
  end
end

class Elf < Hero
  def initialize
  end
end





class Monster < Character
  def initialize(hero_args = {})
    #super
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
