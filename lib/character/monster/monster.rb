require_relative "../character"
# TODO add different categories of monsters like with heros

class Monster < Character
  def initialize(monster_args = {})
    super(monster_args) # make sure to initialize stuff abstracted into the character class
    @dungeon_level = 1
    @inventory = { current_potions: [], current_armor: [], current_weapons: [] }
  end
end
