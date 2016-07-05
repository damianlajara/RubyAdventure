require_relative '../helpers/all_items'

class Treasure
  attr_reader :type, :reward

  def initialize
    @opened = false
    @type = determine_type
  end

  def get_reward_for(hero)
    case rand(0..100)
    when 0..14 then item_reward(hero) # 15% chance
    when 15..100 then money_reward(hero) # 85% chance
    end
  end

  def found?
    @opened
  end

  def open
    @opened = true
  end

  private

  def money_reward(hero)
    money_for = {
      bronze: 2 ** hero.level + rand(120..385),
      silver: 2 ** hero.level + rand(390..740),
      gold: 2 ** hero.level + rand(745..1050)
    }
    { reward: money_for[type], type: 'money' }
  end

  # TODO: If a level is added to every item, then sample a level here based on rarity
  def item_reward(hero)
    hero_items = AllItems::all_items(hero.base_class.downcase) # Mix of armor, weapons, and potions baed on hero class
    item =
      case rand(0..100)
      when 0..9 then hero_items.map { |items| items.last(3) }.flatten.sample # One of the last 3 items # 10% chance
      when 10..47 then  hero_items.map { |items| items[2...-3] }.flatten.sample # Middle portion of items # 38% chance
      when 48..100 then hero_items.map { |items| items.first(2) }.flatten.sample # One of the first 2 items 52% chance
      end
    { reward: item, type: 'item' }
  end

  def determine_type
    case rand(0..100)
    when 0..2 then :gold # 3% chance
    when 3..17 then :silver # 15% chance
    when 18..100 then :bronze # 82% chance
    end
  end

end
