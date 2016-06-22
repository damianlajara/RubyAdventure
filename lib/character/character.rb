require_relative "../helpers/validator"
require_relative "../helpers/mixins"
require_relative "../helpers/utility"

class Character
  include Validator
  include Mixin
  include Procs
  include Utility
  attr_accessor :attack, :defense, :health, :level, :money, :experience
  attr_reader :name, :class, :main_class

  def initialize(character_args = {})
    @name = 'Nameless One'
    @health = character_args[:health] || 100
    @level = character_args[:level] || 1 #TODO remove. monsters dont need it
    @attack = character_args[:attack] || 10
    @defense = character_args[:defense] || 10
    @money = character_args[:money] || 0
    @experience = character_args[:experience] || 0
    @main_class = self.to_s.match(/^#<(\w+):.*/).captures.first
  end

  def alive?
    @health > 0
  end

  def dead?
    !alive?
  end

  # hero.do_damage_to(monster)
  # monster.do_damage_to(hero)
  def do_damage_to(receiver)
    damage = @attack/100 - receiver.defense
    receiver.health -= damage
    damage
  end

end
