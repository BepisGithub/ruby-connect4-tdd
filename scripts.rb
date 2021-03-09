class Board
  def initialize
    @map = Array.new(7, Array.new(6, ' '))
  end

  def write(horizontal_coord, vertical_coord, symbol)
    return 'error' unless symbol.is_a? String
  end
end