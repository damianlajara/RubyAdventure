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
end
