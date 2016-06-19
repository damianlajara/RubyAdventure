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
    min = 1500 + (level**6 - (level * 5) / 2)
    max = min + (level**6 / 6).to_i
    rand(min..max)
  end

  def m_level(level)
    min = level
    max = level**2 + 1
    rand(min..max)
  end

  def m_attack(level)
    (173 + (level**5) / 3)
  end

  def m_defense(level)
    (25 + (level**4) / 8)
  end

  def m_experience(level)
    min = (level ** 3) * 7 - 4
    max = (level**5) + level*7 + 8
    rand(min..max).to_i
  end

  def m_money(level)
    min = level + 120
    max = 120 + level**2 * level + 1
    rand(min..max)
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
