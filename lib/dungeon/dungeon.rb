# TODO Every dungeon has a range of monsters that are only in that level
require_relative "../helpers/formulas"

# class Dungeon
#   attr_accessor :monsters
#   include Formulas
#   TOTAL_LEVELS = 10
#   def initialize(level=1, exp_bonus=0, money_bonus=0)
#     @level = level
#     @exp_bonus = exp_bonus
#     @money_bonus = money_bonus
#     @monsters = []
#     @number_of_treasure_chests = random_treasures(level)
#     @number_of_monsters = random_monsters(level)
#     @number_of_monsters.times do
#       @monsters.push(Monster.new(m_health(level), m_level(level), m_attack(level), m_defense(level), m_money(level), m_experience(level)))
#     end
#   end
# end


class Dungeon
  attr_accessor :monsters
  include Formulas
  TOTAL_LEVELS = 10
  def initialize(level=1, exp_bonus=0, money_bonus=0)
    @level = level
    @exp_bonus = exp_bonus
    @money_bonus = money_bonus
    @monsters = []
    @number_of_treasure_chests = random_treasures(level)
    @number_of_monsters = random_monsters(level)
    @number_of_monsters.times do
      @monsters.push(Monster.new(m_health(level), m_level(level), m_attack(level), m_defense(level), m_money(level), m_experience(level)))
    end
  end
end
