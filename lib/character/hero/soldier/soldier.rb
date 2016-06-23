require_relative '../hero'
# Stats: health mixed, att, mixed below the norm, def high
class Soldier < Hero
  def initialize
    super init_specialization_stats(max_hp: 1300, att: 90, def: 290)
  end
end
