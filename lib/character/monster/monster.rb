require_relative "../character"
require_relative "../../helpers/mixins"
require "pry"


class Monster < Character
  alias_method :reward_money, :money
  alias_method :reward_experience, :experience

  extend Mixin

  def initialize(monster_args = {})
    super(monster_args) # make sure to initialize stuff abstracted into the character class
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end

  def self.all
    monsters_hash = {}
    Dir[File.join(Dir.pwd, 'lib', 'character', 'monster', '*/')].each do |terrain|
      main_class = File.basename(terrain)
      monsters = Dir[File.join(terrain, '*.rb')].map { |file_name| classify(File.basename(file_name, '.rb')) }
      monsters_hash.store(main_class, monsters.compact)
    end
    monsters_hash
  end
end
