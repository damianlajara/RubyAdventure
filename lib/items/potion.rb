require_relative 'item'

class Potion < Item
  attr_reader :health
  def initialize(name, item_args = {})
    raise 'Invalid name entered' if name.empty? || !name.is_a?(String)
    super(name, item_args)
    @health = item_args[:health] || 0
  end
end
