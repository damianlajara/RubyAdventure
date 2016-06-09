#TODO
#Create attribute modules for the armor classes and the potions
#also create different types of soldiers and mages and stuff - take it from the javascript game

module Attributes
  module Potion
    BASE_EFFECT = 10
    BASE_PRICE = 60
    BASE_SELL_VALUE = 35
    EFFECT_OFFSET = 12
    PRICE_OFFSET = 220
    SELL_VALUE_OFFSET = 80
  end

  module Weapon
    module Soldier
      BASE_EFFECT = 12
      BASE_PRICE = 100
      BASE_SELL_VALUE = 50
      EFFECT_OFFSET = 12
      PRICE_OFFSET = 110
      SELL_VALUE_OFFSET = 65
    end
    module Mage
      BASE_EFFECT = 10
      BASE_PRICE = 92
      BASE_SELL_VALUE = 64
      EFFECT_OFFSET = 8
      PRICE_OFFSET = 130
      SELL_VALUE_OFFSET = 50
    end
    module Ranged
      BASE_EFFECT = 14
      BASE_PRICE = 134
      BASE_SELL_VALUE = 86
      EFFECT_OFFSET = 7
      PRICE_OFFSET = 150
      SELL_VALUE_OFFSET = 60
    end
  end

  module Armor
    module Soldier
      BASE_EFFECT = 12
      BASE_PRICE = 100
      BASE_SELL_VALUE = 50
      EFFECT_OFFSET = 12
      PRICE_OFFSET = 110
      SELL_VALUE_OFFSET = 65
    end
    module Mage
      BASE_EFFECT = 10
      BASE_PRICE = 92
      BASE_SELL_VALUE = 64
      EFFECT_OFFSET = 8
      PRICE_OFFSET = 130
      SELL_VALUE_OFFSET = 50
    end
    module Ranged
      BASE_EFFECT = 14
      BASE_PRICE = 134
      BASE_SELL_VALUE = 86
      EFFECT_OFFSET = 7
      PRICE_OFFSET = 150
      SELL_VALUE_OFFSET = 60
    end
  end

end
