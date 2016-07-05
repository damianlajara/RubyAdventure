class Treasure
  attr_reader :type, :reward
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

  def determine_reward
    case rand(0..100)
    when 0..14 then item_reward # 15% chance
    when 15..100 then xp_reward # 85% chance
    end
  end

  def xp_reward
    xp_for = {
       bronze: rand(120..385),
       silver: rand(390..740),
       gold: rand(745..1050)
    }
    { reward: xp_for[type], type: 'experience' }
  end

  # TODO: Make a way where the user can find items as well as xp in the chests
  def item_reward
    # binding.pry
    # item =
    #   case rand(0..100)
    #   when 0..12 then # One of the last 4 armor, weapons , and/or potions # 13% chance
    #   when 13..47 then  # 4..-4 of armor, weapons, and/or potions # 35% chance
    #   when 48..100 then  # One of the first 4 armor, weapons, and/or potions
    #   end
    # { reward: item, type: 'item' }
  end

  def found?
    @opened
  end

  def open
    @opened = true
  end
end
