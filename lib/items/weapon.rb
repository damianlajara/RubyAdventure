require_relative 'item'

class Weapon < Item
  attr_reader :damage
  attr_accessor :equipped
  def initialize(name, item_args = {})
    raise 'Invalid name entered' if name.empty? || !name.is_a?(String)
    super(name, item_args)
    @equipped = false
    @damage = item_args[:damage] || 0
  end
end
