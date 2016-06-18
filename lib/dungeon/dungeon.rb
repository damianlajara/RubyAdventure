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
  attr_reader :total_treasure_chests, :total_steps, :level, :number_of_monsters, :monsters_killed, :total_monster_rewards
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
    @total_monster_rewards = { money: 0, experience: 0 } # Used for the progress bars in the dungeon menu. Keeps track of rewards of monsters before they are killed by the hero
    @monsters_killed = []
    @total_treasure_chests = random_treasures(level)
    @number_of_monsters = 0
    create_monsters
    # @boss = create_boss('Dragon', level) # TODO Every dungeon, has a boss. Should be created based on the level of the user
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
    else
      puts "nevermind..I'm being paranoid. I already killed all the monsters!"
      call_reinforcements
      puts "shouldve called for reinforcements" #debug
    end
  end

  private

  def call_reinforcements
    puts "Oh No! Those bastards called for reinforcements!"
    create_monsters
  end

  def create_monsters
    puts "Creating monsters..." #debug
    monster_count = random_monsters(@level)
    @number_of_monsters += monster_count
    monsters = @all_monsters[@name].map { |monster| Object.const_get(monster) }
    monster_count.times do
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
    @total_monster_rewards[:money] += @monsters.map { |monster| monster.reward_money }.reduce(0, :+)
    @total_monster_rewards[:experience] += @monsters.map { |monster| monster.reward_experience }.reduce(0, :+)
    puts "Initialized dungeon with #{@monsters.count} monsters" #debug
  end

  def commence_attack(hero, monster)
    #TODO add a loop in here that gets user input on what ability he wants to attack with
    while hero.alive? && monster.alive?
      puts "The monster has attacked you!" unless hero.skip_battle_scenes
      puts "You received #{monster.attack} damage" unless hero.skip_battle_scenes
      hero.health = hero.attack - monster.attack
      if hero.alive?
        puts "Your hp: #{hero.health}" unless hero.skip_battle_scenes
        puts "Now you attacked! You have dealt #{hero.attack} Damage" unless hero.skip_battle_scenes
        monster.health -= hero.attack
        if monster.alive?
          puts "Enemy hp: #{monster.health}" unless hero.skip_battle_scenes
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

  def create_boss(klass, level)
    all_monsters.select { |monster| monsters.map(&:to_s).include? klass }.first.new()
  end

end
