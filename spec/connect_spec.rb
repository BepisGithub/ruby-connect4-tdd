require './spec/spec_helper'
require './scripts'

describe Board do
  it 'creates a multidimensional array that uses strings with a space in for the empty values' do
    board = Board.new
    expect(board.instance_variable_get(:@map)).to eq(Array.new(7, Array.new(6, ' ')))
  end
end