require_relative "../character"
require "pry"

class Monster < Character
  alias_method :reward_money, :money
  alias_method :reward_experience, :experience

  def initialize(monster_args = {})
    super(monster_args) # make sure to initialize stuff abstracted into the character class
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end
  def self.all
    monsters_hash = {}
    # Dir[File.join(Dir.pwd, 'lib', 'character', 'monster', '**')].each do |monster_file|
    Dir[File.join(File.dirname(__FILE__), 'lib', 'character', 'monster', '**')].each do |monster_file|
      puts "Inside loop, checking: #{monster_file}"
      main_class = Dir[File.join(monster_file, '*.rb')].compact.map { |file| File.basename(file, '.rb') }.first
      puts "main class: #{main_class}"
      specializations = Dir[File.join(monster_file, 'specialization', '*.rb')].map { |file| File.basename(file, '.rb') }
      puts "specializations: #{specializations}"
      # monsters_hash[main_class] = specializations
      monsters_hash.store(main_class, specializations.compact)
      # binding.pry
    end
    monsters_hash
  end
end

# "executioner" -> Executioner -> Exectioner.new
