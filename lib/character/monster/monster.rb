require_relative "../character"

class Monster < Character
  alias_method :reward_money, :money
  alias_method :reward_experience, :experience

  def initialize(monster_args = {})
    super(monster_args) # make sure to initialize stuff abstracted into the character class
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end
end
