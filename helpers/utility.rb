module Utility
  def error(item="answer")
    puts "Invalid #{item}!"
    return
  end
  def display_empty
    puts "Empty!"
  end
  def capitalize_words(string)
      string.split(" ").map(&:capitalize).join(" ")
  end
end
