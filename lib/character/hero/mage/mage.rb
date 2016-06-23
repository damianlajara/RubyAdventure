require_relative '../hero'
# Stats: health low, def low, att hig
class Mage < Hero
  def initialize
    super init_specialization_stats(max_hp: 600, att: 380, def: 150)
  end
end
