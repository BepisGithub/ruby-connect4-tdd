class Board
  def initialize
    @map = Array.new(7) {Array.new(6, ' ')}
  end

  def write(horizontal_coord, vertical_coord, symbol)
    return 'error' unless symbol.is_a? String
    if @map[horizontal_coord][vertical_coord] == ' '
      @map[horizontal_coord][vertical_coord] = symbol
    else
      return 'error: occupied slot'
    end
  end

  def occupied_slots
    occupied_slots_array = []
    @map.each_with_index do |column, h_index|
      column.each_with_index do |spot, v_index|
        occupied_slots_array.push([h_index, v_index, spot]) unless spot == ' '
      end
    end
    occupied_slots_array
  end
end