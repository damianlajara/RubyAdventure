module Validator
  def validate_num(integer, _max = 9)
    index = integer.to_s =~ /[0-max]/
    index ? true : false
  end
end
