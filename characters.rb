class Character
  attr_accessor :attack, :defense, :hp, :max_hp, :level, :money, :experience
  attr_reader :name, :class, :gender

  #TODO maybe make these into class variables
  @fighter  = %w[Barbarian Knight Paladin Samurai]
  @mage  = %w[Necromancer Wizard Illusionist Alchemist]
  @archer  = %w[Elf Gunner Tamer Poet]

  CLASSES = ["Soldier","Mage","Archer"]
  GENDER = ["Male", "Female"]

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
    print "What is your gender? 1) #{GENDER[0]} 2) #{GENDER[1]} 3) Other "
    @gender = gets.chomp.to_i
    case @gender
      when 1
        @gender = GENDER[0]
      when 2
        @gender = GENDER[1]
      when 3
        print "Enter your preferred gender: "
        @gender = gets.chomp.downcase
      else
        error
    end
  end

  def customize_class
    print "What class Would you like to choose your character from? 1) #{CLASSES[0]} 2) #{CLASSES[1]} 3) #{CLASSES[2]} "
    @class = gets.chomp.to_i
    case @class
      when 1
        #@figher.each { |weapon|  }
        @class = CLASSES[0]
      when 2
        @class = CLASSES[1]

      when 3
        @class = CLASSES[2]

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
