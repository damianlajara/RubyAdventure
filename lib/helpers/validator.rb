module Validator
  # Check the num between a given range from start to max
  def valid_num?(integer, max = 9, start = 0)
    num = integer.is_a?(String) ? integer : integer.to_s
    index = num =~ /[#{start}-#{max}]/
    index ? true : false
  end

  # Make sure the string answer has valid characters and is not empty
  def invalid_answer?(answer)
    !(answer =~ /^[a-z\s]+$/i) || answer.empty?
  end
end
