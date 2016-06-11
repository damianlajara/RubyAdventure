module Utility
  def error(item="answer", terminate=false)
    puts "Invalid #{item}!"
    exit 0 if terminate
  end
  def display_empty
    puts "Empty!"
  end
  def capitalize_words(string)
      string.split(" ").map(&:capitalize).join(" ")
  end
  def default_option(default)
    puts "Error: Entered Invalid Option. Defaulting to #{default}."
    default
  end
end
