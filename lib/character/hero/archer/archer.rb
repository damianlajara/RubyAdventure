require_relative '../hero'
# Stats: health medium, att high, defense low
class Archer < Hero
  def initialize
    super init_specialization_stats(max_hp: 840, att: 480, def: 220)
  end
end
