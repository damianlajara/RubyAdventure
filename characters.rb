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
end
