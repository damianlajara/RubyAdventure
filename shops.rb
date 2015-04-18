class Shop
  #attr_reader :soldier_weapons, :mage_weapons, :archer_weapons, :soldier_armor, :mage_armor, :archer_armor, :potions
 @@soldier_weapon_names = %w[Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur]
 @@mage_weapon_names = %w[Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist]
 @@archer_weapon_names = %w[Arondight Gugnir Susano' Longinus Hrunting Clarent Shinigami Caliburn]

  def initialize
    puts "Initializing shop items ..."
  end

  def self.weapons(class_name="all")
    case class_name
      when "all" then [@@soldier_weapons_names,mage_weapon_names,archer_weapon_names]
      when "soldier" then @@soldier_weapons_names
      when "mage" then @@mage_weapon_names
      when "archer" then @@archer_weapon_names
      else error "shop -> self.weapons()"
    end
  end

  def self.armor(class_name="all")
    case class_name
      when "all" then [@@soldier_armor_names,mage_armor_names,archer_armor_names]
      when "soldier" then @@soldier_armor_names
      when "mage" then @@mage_armor_names
      when "archer" then @@archer_armor_names
      else error "shop -> self.armor()"
    end
  end

end
