require_relative "../helpers/validator"
require_relative "../helpers/mixins"
require_relative "../helpers/utility"

class Character
  include Validator
  include Mixin
  include Procs
  include Utility
  attr_accessor :attack, :defense, :health, :max_hp, :level, :money, :experience
  attr_reader :name, :class, :gender, :base_class, :main_class, :weapon_count, :armor_count, :potion_count,
  :equipped_weapons, :equipped_armor, :inventory

  #FIXME Make this more dynamic by reading in the files from the heros directory
  CLASSES = {
    soldier: %w(Barbarian Knight Paladin Samurai),
    mage: %w(Necromancer Wizard Illusionist Alchemist),
    ranged: %w(Archer Gunner Tamer Elf)
  }

  GENDER = { male: 'Male', female: 'Female', other: 'Other'}

  def initialize(character_args = {})
    @name = 'Nameless One'
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
    @skip_battle_scenes = false
  end

  def reset_stats
    #TODO Create validation in these methods which is why I called self insead of accessing the var directly
    self.health = 100
    self.level = 1
    self.attack = 0
    self.defense = 0
    self.money = 0
    self.experience = 0
    self.max_hp = 100
    #self.dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
    # TODO check if we have to reset these values as well
    # equipped_weapons: [],
    # equipped_armor: [],
    # weapon_count: 0,
    # armor_count: 0,
    # potion_count: 0
  end

  def customize_name
    print 'What would you like your character to be called? '
    @name = capitalize_words gets.chomp.capitalize
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
        second_choice = gets.chomp
        second_choice.empty? ? GENDER[:other] : second_choice
      else
        'Genderless'
      end
  end

  def customize_class
    display_hash_option CLASSES, 'What class would you like to choose your character from? '
    choice = gets.chomp

    @base_class =
      case choice.to_i
      when 1 then :soldier
      when 2 then :mage
      when 3 then :ranged
      else default_option(:soldier)
      end
    @main_class = choose_array_option CLASSES[@base_class]
  end

  def display_game_options_header(spacer_amount=4)
    puts "\n#{'*' * spacer_amount} Game Options #{'*' * spacer_amount}\n"
  end

  def available_game_options
    ["Toggle Battle Scenes", "Change Class", "Change Gender", "Change Name", "Exit"]
  end

  def game_options
    display_game_options_header
    case choose_array_option available_game_options, true
    when 1 then toggle_battle_scenes
    when 2 then change_class
    when 3 then change_gender
    when 4 then change_name
    when 5 then display_exiting_game_options
    else error 'game_options -> first case when 5'
    end
  end

  def display_exiting_game_options
    puts 'Exiting options menu...'
  end

  def print_welcome_message
    if @gender.index(/[aeiou]/) == 0
      puts "Welcome #{@name}! I see you are an #{@gender}, with a class of #{@main_class}!"
    else
      puts "Welcome #{@name}! I see you are a #{@gender}, with a class of #{@main_class}!"
    end
  end

  def customize
    customize_name
    customize_gender
    customize_class
    print_welcome_message
  end

  def yes_or_no_option
    ["yes", "no"]
  end

  def toggle_battle_scenes
    toggle = enable_toggle_skip
    puts "Do you want to #{toggle} all of the battle scenes?"
    case choose_array_option yes_or_no_option, true
    when 1
    puts "Battle scenes have been #{toggle}d."
      @skip_battle_scenes = !@skip_battle_scenes
    else
      puts "Battle scenes will stay #{disable_toggle_skip}d."
    end
  end

  def enable_toggle_skip
    !@skip_battle_scenes ? "disable" : "enable"
  end

  def disable_toggle_skip
    @skip_battle_scenes ? "disable" : "enable"
  end

  def change_class
    puts "Are you sure you want to change your class?\n"
    puts "Your stats will reset and you will lose all of your current weapons and armor!\n"
    case choose_array_option yes_or_no_option, true
    when 1
      self.reset_stats
      customize_class
      puts "Congratulations! You're class has changed to #{@main_class}!"
    else
      puts "Good! I thought the #{@main_class} was better anyway."
    end
  end

  def change_gender
    puts 'Are you sure you want to change your gender?'
    case choose_array_option yes_or_no_option, true
    when 1
      customize_gender
      puts "Congratulations! You're gender has changed to #{@gender}!"
    else
      puts 'Hmmm...I guess it was hard converting to something you\'re not.'
    end
  end

  def change_name
    puts 'Are you sure you want to change your name?'
    case choose_array_option yes_or_no_option, true
    when 1
      customize_name
      puts "Congratulations! You're name has changed to #{@name}!"
    else
      puts 'Awww man...I was looking forward to seeing the weird name you were going to choose!'
    end
  end

end
