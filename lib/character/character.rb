require_relative "../helpers/validator"
require_relative "../helpers/display"
require_relative "../helpers/utility"

class Character
  include Validator
  include Display # TODO: Move to Hero class instead. Not sure monsters need this?
  include Procs
  include Utility
  attr_accessor :attack, :defense, :level, :money, :experience, :max_hp
  attr_reader :name, :class, :main_class, :health

  def initialize(character_args = {})
    # Monsters don't need it, since we are using the dungeon levels to initialize them,
    # but left it in case monsters may need to level up in the future
    @level = character_args[:level] || 1
    @name = 'Nameless One'
    @health = character_args[:health] || 100
    @max_hp = @health # max_hp and health should be the same when initialized
    @attack = character_args[:attack] || 10
    @defense = character_args[:defense] || 10
    @money = character_args[:money] || 0
    @experience = character_args[:experience] || 0
    @description = character_args[:description] || ''
    @main_class = self.to_s.match(/^#<(\w+):.*/).captures.first
  end

  def health=(new_health)
    @health =
      if new_health < 0
        0
      elsif new_health > @max_hp
        @max_hp
      else
        new_health
      end
  end

  def dead?
    @health.zero?
  end

  def alive?
    !dead?
  end

  # hero.do_damage_to(monster)
  # monster.do_damage_to(hero)
  def do_damage_to(receiver)
    damage = @attack/100 - receiver.defense
    receiver.health -= damage
    damage
  end

end
