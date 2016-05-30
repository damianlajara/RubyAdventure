require_relative "../../helpers/attributes"
require_relative "../shop"

class PotionShop < Shop
  include Attributes::Potion
  attr_reader :potions
  def initialize
    @potions = []
    #@@potion_names = %w(Mommy's_Tea Antidote_of_Life Red_Potion' Imperial_Regeneration Oil_of_Health Holy_Light Serum_of_Rejuvination Elixir)
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    POTION_NAMES.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @potions.push(Potion.new(name, { health: effect }, price: price, sell_value: sell_value))
    end
  end

  def potion_count
    POTION_NAMES.length
  end

  def display_potions
    @potions.each_with_index(&Procs::DISPLAY)
  end

end
