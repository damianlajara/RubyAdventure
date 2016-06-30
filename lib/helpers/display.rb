module Display
  def display_hash_option(hash, saying = '')
    print saying
    hash.each_with_index { |(key, _value), index| print "#{index.next}) #{key} " }
  end

  # Two options for result_as_num. If result_as_num is 'false'
  # then return the item at the specified choice entered by the user
  # If the result_as_num is true, then return the choice entered by the user
  def choose_array_option(array_of_choices, result_as_num = false)
    raise 'Array of choices is empty!' unless array_of_choices.any?
    display_array_value_with_index(array_of_choices)
    get_array_option_input(array_of_choices, result_as_num)
  end

  def get_array_option_input(array_of_choices, result_as_num = false)
    print 'To choose a specification, enter the number that corresponds with the option you want: '
    choice = (capture = gets.chomp.match /^([#{1}-#{array_of_choices.count}])$/) ? capture[0] : 'N/A'
    print "\n"
    result_as_num ? choice.to_i : array_of_choices[choice.to_i.pred]
  end

  def display_array_value_with_index(array)
    array.each_with_index { |value, index| puts "#{index.next}) #{value}" }
  end
end

module Procs
  DISPLAY = proc { |item, index| puts "#{index.next}) #{item}" }
  DISPLAY_WEAPON_WITH_STATUS = proc { |weapon, index| puts "#{index.next}) #{sprintf('%-16s', weapon)} Damage: #{sprintf('%-8d', weapon.damage)} Price: #{sprintf('%-8d', weapon.price)} Sell_Value: #{sprintf('%-8d', weapon.sell_value)} Description: #{weapon.description}" }
  DISPLAY_ARMOR_WITH_STATUS  = proc { |armor, index| puts "#{index.next}) #{sprintf('%-16s', armor)} Defense: #{sprintf('%-7d', armor.defense)} Price: #{sprintf('%-8d', armor.price)} Sell_Value: #{sprintf('%-8d', armor.sell_value)} Description: #{armor.description}" }
  DISPLAY_POTION_WITH_STATUS = proc { |potion, index| puts "#{index.next}) #{sprintf('%-16s', potion)} Health: #{sprintf('%-8d', potion.health)} Price: #{sprintf('%-8d', potion.price)} Sell_Value: #{sprintf('%-8d', potion.sell_value)} Description: #{potion.description}" }
end
