require_relative '../hero'
# Stats: health mixed, att average below the norm, def high
class Soldier < Hero
  def initialize
    super init_specialization_stats(max_hp: 1300, att: 360, def: 330)
  end
end
