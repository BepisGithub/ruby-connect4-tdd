require './spec/spec_helper'
require './scripts'

describe Board do
  it 'creates a multi dimensional array (7 horizontal, 6 vertical) to occupy slots' do
    board = Board.new
    expect(board.instance_variable_get(:@map)).to eq(Array.new(7, (Array.new(6))))
  end
  it 'has a multidimensional array that uses strings with a space in for the empty values' do
    board = Board.new
    expect(board.instance_variable_get(:@map)).to eq(Array.new(7, Array.new(6, ' ')))
  end
end