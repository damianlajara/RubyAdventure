require_relative "../monster"

class Zombie < Monster
  def initialize(config_args = {})
    super(config_args)
    @dungeon_level = 2
  end
end
