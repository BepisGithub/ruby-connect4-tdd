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

  def won?
    won = false
    occupied_slots_array = occupied_slots
    first_player_symbol = (occupied_slots_array[0])[2]
    first_player_spots = []
    second_player_symbol = nil
    second_player_spots = []
    occupied_slots_array.each do |slot|
      if slot[2] == first_player_symbol
        first_player_spots.push(slot)
      else
        second_player_symbol = slot[2] if second_player_symbol.nil?
        second_player_spots.push(slot)
      end
    end
    return won if first_player_spots.count < 4 && second_player_spots.count < 4
    
    adjacent = []
    first_player_spots.each do |spot|
      adjacent.push(spot)
    end
    won
  end
end