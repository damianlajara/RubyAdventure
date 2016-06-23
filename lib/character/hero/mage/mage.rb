require_relative '../hero'
# Stats: health low, def low, att hig
class Mage < Hero
  def initialize
    super init_specialization_stats(max_hp: 800, att: 110, def: 220)
  end
end
