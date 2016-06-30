# TODO Every dungeon has a range of monsters that are only in that level
require_relative "../helpers/formulas"

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
  attr_accessor :monsters, :steps_explored, :conquered
  attr_reader :total_treasure_chests, :total_steps, :level, :number_of_monsters, :monsters_killed, :total_monster_rewards
  include Formulas::MonsterHelper
  include Formulas::DungeonHelper
  TOTAL_LEVELS = 10

  def initialize(name='forest', level=1, total_steps=150, exp_bonus=0, money_bonus=0)
    @name = name
    @level = level
    @all_monsters = Monster.all
    @total_steps = total_steps
    @steps_explored = 0 #The number of steps the user has taken in this dungeon
    @exp_bonus = exp_bonus
    @money_bonus = money_bonus
    @conquered = false
    @monsters = []
    @total_monster_rewards = { money: 0, experience: 0 } # Used for the progress bars in the dungeon menu. Keeps track of rewards of monsters before they are killed by the hero
    @monsters_killed = []
    @total_treasure_chests = random_treasures(level)
    @number_of_monsters = 0
    create_monsters
    @boss = create_boss('Dragon', level) # TODO Every dungeon, has a boss. Should be created based on the level of the user
  end

  def all_monsters
    @all_monsters.values.flatten.map(&:constantize)
  end

  def self.enter(hero)
    unless hero.current_dungeon
      hero.current_dungeon = spawn_dungeon(hero.dungeon_level)
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
    end
  end

  def battle_boss(hero)
    commence_attack(hero, @boss)
    won_battle = battle_result(hero, @boss)
    hero.conquer_dungeon if won_battle
  end

  private

  def call_reinforcements
    puts "Oh No! Those bastards called for reinforcements!"
    create_monsters
  end

  def create_monsters
    monster_count = random_monsters(@level)
    @number_of_monsters += monster_count
    monsters = @all_monsters[@name].map(&:constantize)
    monster_count.times do
      random_monster = monsters.sample.new(
        health: m_health(@level),
        level: m_level(@level),
        attack: m_attack(@level),
        defense: m_defense(@level),
        money: m_money(@level),
        experience: m_experience(@level)
      )
      @monsters.push(random_monster)
    end
    @total_monster_rewards[:money] += @monsters.map { |monster| monster.reward_money }.reduce(0, :+)
    @total_monster_rewards[:experience] += @monsters.map { |monster| monster.reward_experience }.reduce(0, :+)
  end

  def commence_attack(hero, monster)
    puts "Hero - lvl: #{hero.level},  hp: #{hero.health},  att: #{hero.attack},  def: #{hero.defense}" if $debug
    puts "Mons - lvl: #{monster.level},  hp: #{monster.health},  att: #{monster.attack},  def: #{monster.defense}" if $debug
    #TODO add a loop in here that gets user input on what ability he wants to attack with
    while hero.alive? && monster.alive?
      puts "The monster has attacked you!" unless hero.skip_battle_scenes
      monster_damage = monster.do_damage_to(hero)
      puts "You received #{monster_damage} damage" unless hero.skip_battle_scenes
      if hero.alive?
        puts "Your hp: #{hero.health}" unless hero.skip_battle_scenes
        # TODO: Add a way for the hero to check their inventory here in order to change weapons, take potions, etc
        # Also make it where the user can choose what ability to use (Depending on the class they chose)
        hero_damage = hero.do_damage_to(monster)
        puts "Now you attacked! You have dealt #{hero_damage} Damage" unless hero.skip_battle_scenes
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
      true
    elsif hero.dead? && monster.alive?
      puts "You have died!"
      hero.reset_stats_after_death
      false
    end
  end

  def create_boss(klass, level)
    all_monsters.find { |monster| monster.to_s == klass.classify }.new(
      health: m_health(@level, boss: true),
      level: m_level(@level, boss: true),
      attack: m_attack(@level, boss: true),
      defense: m_defense(@level, boss: true),
      money: m_money(@level, boss: true),
      experience: m_experience(@level, boss: true)
    )
  end

end
