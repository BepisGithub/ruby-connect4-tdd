class Board
  def initialize
    @map = Array.new(7, Array.new(6, ' '))
  end

  def write(horizontal_coord, vertical_coord, symbol)
    return 'error' unless symbol.is_a? String
    if @map[horizontal_coord][vertical_coord] == ' '
      @map[horizontal_coord][vertical_coord] = symbol
    else
      return 'error: occupied slot'
    end
  end
end