class Shop
  #attr_reader :soldier_weapons, :mage_weapons, :archer_weapons, :soldier_armor, :mage_armor, :archer_armor, :potions
 @@soldier_weapon_names = %w(Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur)
 @@mage_weapon_names = %w(Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist)
 @@ranged_weapon_names = %w(Arondight Gugnir Susano' Longinus Hrunting Clarent Shinigami Caliburn)

  def initialize
    puts "Initializing shop items ..."
  end

  def self.weapons(class_name="all")
    case class_name
    when "all" then [@@soldier_weapons_names, @@mage_weapon_names, @@ranged_weapon_names]
      when "soldier" then @@soldier_weapons_names
      when "mage" then @@mage_weapon_names
      when "ranged" then @@ranged_weapon_names
      else error "shop -> self.weapons()"
    end
  end

  def self.armor(class_name="all")
    case class_name
    when "all" then [@@soldier_armor_names, @@mage_armor_names, @@ranged_armor_names]
      when "soldier" then @@soldier_armor_names
      when "mage" then @@mage_armor_names
      when "ranged" then @@ranged_armor_names
      else error "shop -> self.armor()"
    end
  end

end

class SoldierWeaponShop < Shop
  include SoldierWeaponAttributes

  def initialize
    @soldier_weapons = []
    if $debug then puts "initializing soldier weapons" end
    #@@soldier_weapon_names = %w[Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur]
    effect = BASE_EFFECT
    price = BASE_PRICE
    sell_value = BASE_SELL_VALUE

    @@soldier_weapon_names.each do |name|
      effect += EFFECT_OFFSET
      price += PRICE_OFFSET
      sell_value += SELL_VALUE_OFFSET
      @soldier_weapons.push(Weapon.new(name, { damage: effect }, price: price, sell_value: sell_value))
    end
  end

  def display_weapons
    @soldier_weapons.each(&Procs::DISPLAY)
  end

end

  class MageWeaponShop < Shop
    include MageWeaponAttributes
    def initialize
      @mage_weapons = []
      if $debug then puts "initializing mage weapons" end
      #@@mage_weapon_names = %w[Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist]
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      #use each with index
      @@mage_weapon_names.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @mage_weapons.push(Weapon.new(name, { damage: effect }, price: price, sell_value: sell_value))
      end
    end

    def display_weapons
      @mage_weapons.each(&Procs::DISPLAY)
    end

  end

  class RangedWeaponShop < Shop
    include RangedWeaponAttributes
    def initialize
      @ranged_weapons = []
      if $debug then puts "initializing ranged weapons" end
      #@@archer_weapon_names = %w[Arondight Gugnir Susano' Longinus Hrunting Clarent Shinigami Caliburn]
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      @@ranged_weapon_names.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @ranged_weapons.push(Weapon.new(name, { damage: effect }, price: price, sell_value: sell_value))
      end
    end

    def display_weapons
      @ranged_weapons.each(&Procs::DISPLAY)
    end

  end

# TODO include the mods for these also

  class SoldierArmorShop < Shop
    def initialize
      @soldier_armor = []
      @@soldier_armor_names = %w(Calcite Mirage Djinn Shape_Shifter Dark_Prism Fatal_Sith Devastator Override)
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      @@soldier_armor_names.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @soldier_armor.push(Armor.new(name, { defense: effect }, price: price, sell_value: sell_value))
      end
    end
  end

  class MageArmorShop < Shop
    def initialize
      @mage_armor = []
      @@mage_armor_names = %w(Colossus Eternal_Vanguard Prism Valkyrie Trident Eclipse Lunar_Spirit Astral_Inducer)
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      @@mage_armor_names.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @mage_armor.push(Armor.new(name, { defense: effect }, price: price, sell_value: sell_value))
      end
    end
  end

  class RangedArmorShop < Shop
    def initialize
      @ranged_armor = []
      @@ranged_armor_names = %w(Nightmare Ashura Ichimonji Lionheart Ascalon Nirvana Chaotic_Axis Ominous_Judgement)
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      @@ranged_armor_names.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @ranged_armor.push(Armor.new(name, { defense: effect }, price: price, sell_value: sell_value))
      end
    end
  end

  class PotionShop < Shop
    def initialize
      @potions = []
      @@potion_names = %w(Mommy's_Tea Antidote_of_Life Red_Potion' Imperial_Regeneration Oil_of_Health Holy_Light Serum_of_Rejuvination Elixir)
      effect = BASE_EFFECT
      price = BASE_PRICE
      sell_value = BASE_SELL_VALUE

      @@potion_names.each do |name|
        effect += EFFECT_OFFSET
        price += PRICE_OFFSET
        sell_value += SELL_VALUE_OFFSET
        @potions.push(Potion.new(name, { health: effect }, price: price, sell_value: sell_value))
      end
    end
  end
