require_relative '../hero'
# Stats: health medium, att high, defense low
class Archer < Hero
  def initialize
    super init_specialization_stats(max_hp: 960, att: 98, def: 232)
  end
end
