
# TODO -> Add a description to every Item

class Item
  attr_reader :name, :price, :sell_value, :description

  def initialize(name = "", item_args) #item_args = {}
    @name = name
    @price = item_args[:price] || 0
    @sell_value = item_args[:sell_value] || 0
  end

  def to_s
    @name
  end
end

# item = Item.new("Item 1 (Item)", { health: 100 }, price: 100, sell_value: 50)
# p item

class Potion < Item
  attr_reader :health
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @health = specialty[:health] || 0
  end
end

# item1 = Potion.new("Item 2 (Potion)", { health: 100 }, price: 100, sell_value: 50)
# p item1

class Weapon < Item
  attr_reader :damage
  #include List_of_weapons
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @damage = specialty[:damage] || 0
  end
end

#item2 = Weapon.new("Item 3 (Weapon)", { damage: 150 }, price: 150, sell_value: 100)
#p item2

class Armor < Item
  attr_reader :defense
  def initialize(name, specialty, item_args)
    super(name, item_args)
    @defense = specialty[:defense] || 0
  end
end

#item3 = Armor.new("Item 4 (Armor)", { defense: 200 }, price: 200, sell_value: 100)
#p item3
