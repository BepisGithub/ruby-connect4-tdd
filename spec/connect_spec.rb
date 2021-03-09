require './spec/spec_helper'
require './scripts'

describe Board do
  describe '#initialize' do
    it 'creates a multidimensional array that uses strings with a space in for the empty values' do
      board = Board.new
      expect(board.instance_variable_get(:@map)).to eq(Array.new(7, Array.new(6, ' ')))
    end
  end
  describe '#write' do
    it 'occupies a slot with a given symbol' do
      board = Board.new
      horizontal_coord = 0
      vertical_coord = 0
      symbol = 'x'
      board.write(horizontal_coord, vertical_coord, symbol)
      expect(board.instance_variable_get(:@map)).not_to eq(Array.new(7, Array.new(6, ' ')))
    end
  end
end