class Treasure
  def initialize
    @opened = false
    @type = determine_type
    @reward = determine_reward
  end

  def determine_type
    case rand(0..100)
    when 0..2 then :gold # 3% chance
    when 3..17 then :silver # 15% chance
    when 18..100 then :bronze # 82% chance
    end
  end

  # TODO: Have every treasure actually give a reward based on its type
  def determine_reward
  end

  def found?
    @opened
  end

  def open
    @opened = true
  end
end
