require_relative 'item'

class Key < Item
  class << self
    # Create a key based on it's rarity. Used for when a hero obtains all the hints necessary to unlock a key
    def unlock_with_hints
      case rand(0..100)
      when 0..4 then Key.make 'gold' # 5% chance
      when 5..19 then Key.make 'silver' # 15% chance
      when 20..100 then Key.make 'bronze' # 80% chance
      end
    end

    def make(key_type)
      # TODO: add validation for key_type
      new key_type
    end

    def types
      # the types of keys, in order of importance
      %w(bronze silver gold) # TODO: change to %i
    end

    # Creates/forges higher level keys and returns a new array with the newly forged keys
    # 3 bronze keys -> 1 silver key
    # 3 silver keys -> 1 gold key
    def forge(list_of_keys)
      # Retain a copy of the gold keys we will whitelist, in order to add to the newly forged keys array
      gold_keys = list_of_keys.select { |key| key.name == 'gold' }
      # filter out the keys with a type/name of gold and then sort them by the name/type
      sorted_white_listed_keys = list_of_keys.reject { |key| key.name == 'gold' }.sort_by(&:name)
      # Categorize them by type/name. All of the bronze keys in one array, and all the silver in another
      categorized_keys = sorted_white_listed_keys.slice_when { |key1, key2| key1.name != key2.name }
      # Only select the categorized keys that have more than 3 keys, since for every 3 keys we will forge one
      enough_keys = categorized_keys.select { |array| array.count >= 3 }
      puts 'Forging keys...'
      if enough_keys.any?
        enough_keys.map do |sorted_keys_by_type|
          sorted_keys_by_type.each_slice(3).map do |slice|
            if slice.count == 3
              type = slice.first.name
              puts "Using 3 #{type} keys to forge a #{types[types.index(type).next]} key "
              # only need one key's name since all keys in this slice will have the same name since they're sorted
              new(types[types.index(type).next])
            else
              slice
            end
          end.flatten
        end.concat(gold_keys).flatten
      else
        puts 'You do not have enough of the same type of keys to forge new ones.'
      end
    end
  end

  def initialize(name = 'bronze')
    item_args = market_value(name).merge(description: "A key used to open #{name} treasure chests")
    super(name, item_args)
  end

  # alias
  def type
    @name.to_sym
  end

  private

  def market_value(name)
    sell_value =
      case name.downcase
      when 'bronze' then 45
      when 'silver' then 260
      when 'gold' then 500
      end
    { sell_value: sell_value }
  end
end
# key.new('silver')
