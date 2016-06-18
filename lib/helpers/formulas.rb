module Formulas
  def random_treasures(level)
    min = level/4
	  max = (level / 2 - level).to_i.abs
    rand(min..max)
  end

  def random_monsters(level)
    min = level/2 + level
    max = (level**1/4) + (Math.log2(level**6 + 1).to_i) + 1
    rand(min..max)
  end

  def m_health(level)
    min = 100 + (level**4 - (level ** 5) / 23)
	  max = min + (level**4 / 4).to_i
    rand(min..max)
  end

  def m_level(level)
    rand(level..level**2+1)
  end

  def m_attack(level)
    rand(level+30..30+level**3/2).to_i
  end

  def m_defense(level)
    rand(level+15..15+level**4/2).to_i
  end

  def m_experience(level)
    rand((level*8)..(level*8 + level**4 + (3 / 2))).to_i
  end

  def m_money(level)
    rand(level+120..120+level**2*level+1)
  end
end
