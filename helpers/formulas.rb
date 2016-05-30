module Formulas
  def random_treasures(index)
    rand(0..(index*1.5-1)).to_i
  end
  def random_monsters(index)
    rand(1..(index + index/2 + 1)).to_i
  end
  def m_health(index)
    rand(100..100 + rand(index*2-2..index*2+1))
  end
  def m_level(index)
    rand(index..index**2+1)
  end
  def m_attack(index)
    rand(index+30..30+index**3/2).to_i
  end
  def m_defense(index)
    rand(index+15..15+index**4/2).to_i
  end
  def m_experience(index)
    rand((index*8)..(index*8 + index**4 + (3 / 2))).to_i
  end
  def m_money(index)
    rand(index+120..120+index**2*index+1)
  end
end
