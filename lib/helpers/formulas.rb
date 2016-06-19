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

  def m_health(level, is_boss={})
    min = 1500 + (level**6 - (level * 5) / 2)
    max = min + (level**6 / 6).to_i
    is_boss[:boss] ? max : rand(min..max)
  end

  def m_level(level, is_boss={})
    min = level
    max = level**2 + 1
    is_boss[:boss] ? max : rand(min..max)
  end

  def m_attack(level, is_boss={})
    base = (173 + (level**5) / 3)
    is_boss[:boss] ? base * 2 : base
  end

  def m_defense(level, is_boss={})
    base = (25 + (level**4) / 8)
    is_boss[:boss] ? base * 2 : base
  end

  def m_experience(level, is_boss={})
    min = (level ** 3) * 7 - 4
    max = (level**5) + level*7 + 8
    is_boss[:boss] ? max * 3 : rand(min..max).to_i
  end

  def m_money(level, is_boss={})
    min = level + 120
    max = 120 + level**2 * level + 1
    is_boss[:boss] ? max : rand(min..max)
  end

  # Formula for calculating steps
  # 2.upto(12) do |total|
  # 	# total is simulating the total dice roll
  # 	base_range = 1
  # 	max_range = total/2 + 1
  # 	random = "rand(#{base_range}..#{max_range})"
  # 	base1 = (total/4)**3
  # 	base2 = ((total*2)/4)**(2) + 1
  # 	bonus = base1+base2
  # 	puts "#{total}) #{random} + #{base1} + #{base2} = #{random} + #{bonus} = range(#{bonus + base_range} to #{bonus + max_range})"
  # end
  def random_steps(roll)
    rand(1..(roll[:total]/2 + 1)) + (roll[:total]/4)**3 + ((roll[:total]*2)/4)**(2) + 1
  end

end
