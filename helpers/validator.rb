module Validator
  def validate_num(integer,max=9)
    integer.to_s =~ %r{[0-max]}
  end
end
