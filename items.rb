class Item
  attr_reader :name, :price, :sell_value, :description
  def initialize(name, price, sell_value)
    @name = name
    @price = price
    @sell_value = sell_value
  end

  def to_s
    @name
  end
end

class Potion < Item
  attr_reader :health
  def initialize(name, health=0, price=0, sell_value=0)
    super(name, price, sell_value)
    @health = health
  end
end

class Weapon < Item
  attr_reader :damage
  #include List_of_weapons
  def initialize(name, damage=0, price=0, sell_value=0)
    super(name, price, sell_value)
    @damage = damage
  end
end

class Armor < Item
  attr_reader :defense
  def initialize(name, defense=0, price=0, sell_value=0)
    super(name, price, sell_value)
    @defense = defense
  end
end
