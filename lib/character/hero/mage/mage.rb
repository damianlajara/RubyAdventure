require_relative '../hero'
# Stats: health low, def low, att high
class Mage < Hero
  def initialize
    super init_specialization_stats(max_hp: 820, att: 520, def: 240)
  end
end
