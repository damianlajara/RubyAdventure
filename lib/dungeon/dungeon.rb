# TODO Every dungeon has a range of monsters that are only in that level
require_relative "../helpers/formulas"
require 'pry'
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
    # @number_of_monsters.times do
    #   @monsters.push(Monster.new(m_health(level), m_level(level), m_attack(level), m_defense(level), m_money(level), m_experience(level)))
    # end
  end
  def self.enter(hero)
    unless hero.current_dungeon
      hero.current_dungeon = Dungeon.new(hero.dungeon_level)
      puts "Welcome to Dungeon level #{hero.dungeon_level}! May luck be on your side."
    else
      puts "Welcome back to dungeon level #{hero.dungeon_level}. Go finish what you started!"
    end
    go_to_dungeon_level(hero)
  end

  def self.go_to_dungeon_level(hero)
    random_dice1 = rand(1..6)
    random_dice2 = rand(1..6)
    total = random_dice1 + random_dice2
    puts "You rolled a #{random_dice1} and a #{random_dice2} for a total of #{total}!"
    puts total.even? ? battle_monster(hero) : "Missed!"
  end
end
