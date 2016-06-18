class Treasure
  def initialize
    @opened = false
  end

  def found?
    @opened
  end

  def open
    @opened = true
  end
end
