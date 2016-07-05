module AllItems
  ITEM_VALUES =
    {
      weapon: {
        soldier: {
          base_effect: 12,
          base_price: 100,
          base_sell_value: 50,
          effect_offset: 12,
          price_offset: 110,
          sell_value_offset: 65
        },
        mage: {
          base_effect: 10,
          base_price: 92,
          base_sell_value: 64,
          effect_offset: 8,
          price_offset: 130,
          sell_value_offset: 50
        },
        archer: {
          base_effect: 14,
          base_price: 134,
          base_sell_value: 86,
          effect_offset: 7,
          price_offset: 159,
          sell_value_offset: 60
        }
      },
      armor: {
        soldier: {
          base_effect: 12,
          base_price: 100,
          base_sell_value: 50,
          effect_offset: 12,
          price_offset: 110,
          sell_value_offset: 65
        },
        mage: {
          base_effect: 10,
          base_price: 92,
          base_sell_value: 64,
          effect_offset: 8,
          price_offset: 130,
          sell_value_offset: 50
        },
        archer: {
          base_effect: 14,
          base_price: 134,
          base_sell_value: 86,
          effect_offset: 7,
          price_offset: 159,
          sell_value_offset: 60
        }
      },
      potion: {
        base_effect: 10,
        base_price: 60,
        base_sell_value: 35,
        effect_offset: 12,
        price_offset: 220,
        sell_value_offset: 80
      }
    }.freeze

  POTION_NAMES = %w(Mommys_Tea Antidote_of_Life Red_Potion Imperial_Regeneration Oil_of_Health Holy_Light Serum_of_Rejuvination Elixir).freeze

  ARMOR_NAMES =
    {
      soldier: %w(Calcite Mirage Djinn Shape_Shifter Dark_Prism Fatal_Sith Devastator Override),
      mage: %w(Colossus Eternal_Vanguard Prism Valkyrie Trident Eclipse Lunar_Spirit Astral_Inducer),
      archer: %w(Nightmare Ashura Ichimonji Lionheart Ascalon Nirvana Chaotic_Axis Ominous_Judgement)
    }.freeze

  WEAPON_NAMES =
    {
      soldier: %w(Meito Ichimonji Shusui Apocalypse Blade_of_Scars Ragnarok Eternal_Darkness Masamune Soul_Calibur),
      mage: %w(Neil_Vajra Brionac Claimh_Solais Durandal Kusanagi Tizona Zulfiqar Orcrist),
      archer: %w(Arondight Gugnir Susanoo Longinus Hrunting Clarent Shinigami Caliburn)
    }.freeze

  # TODO: Add validation for item_type
  # get_items_of_type(:weapon, :soldier)
  def get_items_of_type(item_type, class_type = :soldier)
    effect = ITEM_VALUES[item_type][:base_effect] || ITEM_VALUES[item_type][class_type][:base_effect]
    price = ITEM_VALUES[item_type][:base_price] || ITEM_VALUES[item_type][class_type][:base_price]
    sell_value = ITEM_VALUES[item_type][:base_sell_value] || ITEM_VALUES[item_type][class_type][:base_sell_value]
    item =
      case item_type
      when :weapon then { names: WEAPON_NAMES[class_type], specialty: :damage, klass: Weapon }
      when :armor then  { names: ARMOR_NAMES[class_type], specialty: :defense, klass: Armor }
      when :potion then { names: POTION_NAMES, specialty: :health, klass: Potion }
      end
    item[:names].map do |name|
      effect += ITEM_VALUES[item_type][:effect_offset] || ITEM_VALUES[item_type][class_type][:effect_offset]
      price += ITEM_VALUES[item_type][:price_offset] || ITEM_VALUES[item_type][class_type][:price_offset]
      sell_value += ITEM_VALUES[item_type][:sell_value_offset] || ITEM_VALUES[item_type][class_type][:sell_value_offset]
      item[:klass].new(name, item[:specialty] => effect, price: price, sell_value: sell_value)
    end
  end
end
