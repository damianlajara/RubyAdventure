require_relative '../hero'
# Stats: health mixed, att, mixed below the norm, def high
class Soldier < Hero
  def initialize
    super init_specialization_stats(max_hp: 1250, att: 80, def: 280)
  end
end
