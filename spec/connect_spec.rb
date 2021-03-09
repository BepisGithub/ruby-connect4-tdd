require './spec/spec_helper'
require './scripts'

describe Board do
  describe '#initialize' do
    it 'creates a multidimensional array that uses strings with a space in for the empty values' do
      board = Board.new
      expect(board.instance_variable_get(:@map)).to eq(Array.new(7) {Array.new(6, ' ')})
    end
  end
  describe '#write' do
    it 'occupies a slot with a given symbol' do
      board = Board.new
      horizontal_coord = 0
      vertical_coord = 0
      symbol = 'x'
      board.write(horizontal_coord, vertical_coord, symbol)
      expectation = Array.new(7) {Array.new(6, ' ')}
      expectation[horizontal_coord][vertical_coord] = 'x'
      expect(board.instance_variable_get(:@map)).to eq(expectation)
    end
    it 'doesn\'t override an occupied slot' do
      board = Board.new
      board.write(0, 0, 'x')
      expect(board.write(0, 0, 'o')).to eq('error: occupied slot')
    end
  end

  describe '#occupied_slots' do
    it 'returns an array of coordinates of each occupied slot' do
      board = Board.new
      board.write(0, 0, 'x')
      expect(board.occupied_slots).to eq([[0, 0, 'x']])
    end
  end

  # describe '#won?' do
  #   it 'checks each occupied slot. for each occupied slot it checks all adjacent positions and marks down the current one
  #   in an array. then it checks the adjacent ones of each position unless it is in the array. if there are four then return true' do
  #     board = Board.new
  #     board.write(0, 0, 'x')
  #     board.write(1, 1, 'x')
  #     board.write(2, 2, 'x')
  #     board.write(3, 3, 'x')
  #     expect(board.won?).to be_truthy
  #   end
  # end
end