module Customize
  GENDER = { male: 'Male', female: 'Female', other: 'Other' }.freeze

  # Called when user dies. Only lose money, exp and all items
  def reset_stats_after_death
    puts "You wake up in a hospital...not knowing where you are. Life has given you a second chance. Go get em'!"
    # TODO: Create validation in these methods which is why I called self insead of accessing the var directly
    self.health = @max_hp
    self.money = 0
    self.experience = 0
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
    @equipped_weapons = []
    @equipped_armor = []
  end

  def customize_name
    print 'What would you like your character to be called? '
    name = capitalize_words gets.chomp.capitalize
    @name = name.empty? ? @name : name
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

  def customize
    customize_name
    customize_gender
    display_welcome_message
  end

  def yes_or_no_option
    %w(yes no)
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
    !@skip_battle_scenes ? 'disable' : 'enable'
  end

  def disable_toggle_skip
    @skip_battle_scenes ? 'disable' : 'enable'
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

  def display_game_options_header(spacer_amount = 4)
    puts "#{'*' * spacer_amount} Game Options #{'*' * spacer_amount}\n"
  end

  def available_game_options
    ['Change Name', 'Change Gender', 'Toggle Battle Scenes']
  end

  def game_options
    display_game_options_header
    case choose_array_option available_game_options, true
    when 1 then change_name
    when 2 then change_gender
    when 3 then toggle_battle_scenes
    else
      invalid
      display_exiting_game_options
    end
  end

  def display_exiting_game_options
    puts 'Exiting options menu...'
  end

  def display_welcome_message
    puts "#{@name}, welcome to Ruby Adventure! I see you are a #{@gender}, with a class of #{main_class}!"
  end
end
