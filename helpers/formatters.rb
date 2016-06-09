module Formatter
  def display_formatted_weapon_choice_header(base_class)
    puts "\n# #{sprintf("%19s", base_class << " Weapon Name")}#{sprintf("%10s", "Damage")} #{sprintf("%10s", "Price")} #{sprintf("%13s", "Sell_Value")}\n"
  end
  def display_formatted_armor_choice_header(base_class)
    puts "\n# #{sprintf("%19s", base_class << " Armor Name")}#{sprintf("%10s", "Defense")} #{sprintf("%10s", "Price")} #{sprintf("%13s", "Sell_Value")}\n"
  end
  def display_formatted_potion_choice_header
    puts "\n# #{sprintf("%12s", "Potion Name")}#{sprintf("%17s", "Health")} #{sprintf("%10s", "Price")} #{sprintf("%13s", "Sell_Value")}\n"
  end
  def display_graphical_line_break(amount_of_seperators=10)
    puts "#{("*~"*amount_of_seperators).chop}"
  end
end
