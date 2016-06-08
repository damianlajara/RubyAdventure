require_relative "../helpers/validator"

class Character
  include Validator
  attr_accessor :attack, :defense, :health, :max_hp, :level, :money, :experience
  attr_reader :name, :class, :gender, :base_class, :main_class, :weapon_count, :armor_count, :potion_count,
  :equipped_weapons, :equipped_armor

  #FIXME Make this more dynamic by reading in the files from the heros dir
  CLASSES = {
    soldier: %w(Barbarian Knight Paladin Samurai),
    mage: %w(Necromancer Wizard Illusionist Alcheemist),
    ranged: %w(Archer Gunner Tamer Elf)
  }

  GENDER = { male: 'Male', female: 'Female' }

  def initialize(character_args = {})
    @health = character_args[:health] || 100
    @level = character_args[:level] || 1
    @attack = character_args[:attack] || 10
    @defense = character_args[:defense] || 10
    @money = character_args[:money] || 0
    @experience = character_args[:exp] || 0
    @equipped_weapons = []
    @equipped_armor = []
    @weapon_count = 0
    @armor_count = 0
    @potion_count = 0
  end

  def reset_stats
    #TODO Create validation in these methods which is why I called self inseat of accessing the var directly
    self.health = 100
    self.level = 1
    self.attack = 0
    self.defense = 0
    self.money = 0
    self.experience = 0
    self.max_hp = 100
    #self.dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
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

    @base_class =
      case choice
      when 1 then "soldier"
      when 2 then "mage"
      when 3 then "ranged"
      else error 'customize_class() -> base_class case statement'
      end

    @main_class =
      case choice
      when 1 then choose_array_option CLASSES[:soldier]
      when 2 then choose_array_option CLASSES[:mage]
      when 3 then choose_array_option CLASSES[:ranged]
      else error 'customize_class() -> main_class case statement'
      end
  end

  def print_game_options
    puts "\n#{'*' * 4} Game Options #{'*' * 4}\n"
    puts '1) Toggle Battle Scenes'
    puts '2) Change Class'
    puts '3) Change Gender'
    puts '4) Change Name'
    puts '5) Exit'
  end

  def game_options
    print_game_options
    option = gets.chomp.to_i
    case option
    when 1 then toggle_battle_scenes
    when 2 then change_class
    when 3 then change_gender
    when 4 then change_name
    when 5 then puts 'Exiting options menu...'
    else error 'game_options -> first case when 5'
    end
  end

  def print_welcome_message
    if @gender.index(/[aeiou]/) == 0
      puts "\nWelcome #{@name}! I see you are an #{@gender}, with a class of #{@main_class}!"
    else
      puts "\nWelcome #{@name}! I see you are a #{@gender}, with a class of #{@main_class}!"
    end
  end

  def customize
    customize_name
    customize_gender
    customize_class
    print_welcome_message
  end

  def toggle_battle_scenes
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
  end

  def change_class
    puts "Are you sure you want to change your class?\n"
    puts "Your stats will reset and you will lose all of your current weapons and armor!\n"
    puts '1) Yes 2) No '
    class_choice = gets.chomp.to_i
    case class_choice
    when 1
      self.reset_stats
      customize_class
      puts "Congratulations! You're class has changed to #{@main_class}!"
    when 2
      puts "Good! I thought the #{@main_class} was better anyway."
    else
      error 'game_options -> first case when 2 -> second case'
    end
  end

  def change_gender
    puts 'Are you sure you want to change your gender?'
    puts '1) Yes 2) No '
    gender_choice = gets.chomp.to_i
    case gender_choice
    when 1
      customize_gender
      puts "Congratulations! You're gender has changed to #{@gender}!"
    when 2
      puts 'Hmmm...I guess it was hard converting to something you\'re not.'
    else
      error 'game_options -> first case when 3 -> second case'
    end
  end

  def change_name
    puts 'Are you sure you want to change your name?'
    puts '1) Yes 2) No '
    name_choice = gets.chomp.to_i
    case name_choice
    when 1
      customize_name
      puts "Congratulations! You're name has changed to #{@name}!"
    when 2
      puts 'Awww man...I was looking forward to seeing the weird name you were going to choose!'
    else
      error 'game_options -> first case when 4 -> second case'
    end
  end

end
