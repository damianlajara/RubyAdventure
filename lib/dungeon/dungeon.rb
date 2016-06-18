# TODO Every dungeon has a range of monsters that are only in that level
require_relative "../helpers/formulas"
require 'pry'

# underworld
  # Zombie
  # Vampire
  # Ghost
# mountains
  # Dragon
  # Golem
# forest
  # Goblin
  # Ogre
  # Wolf

class Dungeon
  attr_accessor :monsters, :steps_explored
  attr_reader :total_treasure_chests, :total_steps, :level, :number_of_monsters
  include Formulas
  TOTAL_LEVELS = 10

  def initialize(name='forest', level=1, total_steps=150, exp_bonus=0, money_bonus=0)
    @name = name
    @level = level
    @all_monsters = Monster.all
    @total_steps = total_steps
    @steps_explored = 0 #The number of steps the user has taken in this dungeon
    @exp_bonus = exp_bonus
    @money_bonus = money_bonus
    @monsters = []
    @monsters_killed = []
    @total_treasure_chests = random_treasures(level)
    @number_of_monsters = random_monsters(level)
    create_monsters
    # @boss = create_boss('Dragon') # TODO Every dungeon, has a boss. Should be created based on the level of the user
  end

  def all_monsters
    @all_monsters.values.flatten.map { |monster| Object.const_get(monster) }
  end

  def self.enter(hero)
    unless hero.current_dungeon
      hero.current_dungeon = self.spawn_dungeon(hero.dungeon_level)
      puts "Welcome to Dungeon level #{hero.dungeon_level}! May luck be on your side."
    else
      puts "Welcome back to dungeon level #{hero.current_dungeon.level}. Go finish what you started!"
    end
  end

  def create_monsters
    monsters = @all_monsters[@name].map { |monster| Object.const_get(monster) }
    @number_of_monsters.times do
      random_monster = monsters.sample.new(
        health: m_health(@level),
        level: m_level(@level),
        attack: m_attack(@level),
        defense: m_defense(@level),
        money: m_money(@level),
        exp: m_experience(@level)
      )
      @monsters.push(random_monster)
    end
  end

  def self.spawn_dungeon(level)
    case level
    when 1..4 then Dungeon.new('forest', level)
    when 5..9  then Dungeon.new('underworld', level)
    when 10..12 then Dungeon.new('mountain', level)
    end
  end

  def battle(hero)
    puts "You hear footsteps..."
    if @monsters.any?
      puts "It's a monster! Prepare for battle!"
      monster = @monsters.shift
      commence_attack(hero, monster)
      battle_result(hero, monster)
    elsif
      puts "nevermind..I'm being paranoid. I already killed all the monsters."
    end
  end

  def commence_attack(hero, monster)
    while hero.alive? && monster.alive?
      puts "The monster has attacked you!"
      puts "You received #{monster.attack} damage"
      hero.health = hero.attack - monster.attack
      if hero.alive?
        puts "Your hp: #{hero.health}"
        puts "Now you attacked! You have dealt #{hero.attack} Damage"
        monster.health -= hero.attack
        if monster.alive?
          puts "Enemy hp: #{monster.health}"
        end
      end
    end
  end

  def battle_result(hero, monster)
    if hero.alive? && monster.dead?
      puts "Congratulations! You killed the enemy!"
      hero.loot(monster)
      @monsters_killed.push(monster)
    elsif hero.dead? && monster.alive?
      puts "You have died!"
    end
  end

  private
  def create_boss(klass, level)
    all_monsters.select { |monster| monsters.map(&:to_s).include? klass }.first.new
  end

end
