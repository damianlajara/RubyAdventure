module Validator
  def validate_num(integer, _max = 9)
    integer.to_s =~ /[0-max]/
  end
end
