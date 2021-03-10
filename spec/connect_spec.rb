require './spec/spec_helper'
require './scripts'
# YOU NEED TO MAKE THE PROGRAM USED A GRAPH TO REPRESENT THE GRID LIKE YOU DID IN THE KNIGHTS TRAVAILS THING

describe LinkedNode do
  describe 'the data it holds' do
    it 'holds data for itself' do
      new_node = LinkedNode.new('hey')
      expect(new_node.data).not_to be nil
    end
    it 'holds a pointer for the next node' do
      new_node = LinkedNode.new('hey', LinkedNode.new('my guy'))
      expect(new_node.next_node.data).to eq('my guy')
    end
  end
end

describe LinkedList do
  describe '#initialize' do
    it 'can be initialized without any arguments' do
      list = LinkedList.new
    end
  end
  describe 'the data it holds' do
    it 'holds a head pointer' do
      head = LinkedNode.new('head')
      list = LinkedList.new(head)
      expect(list.head).to be_truthy
    end
    describe 'the tail pointer' do
      it 'holds a tail pointer' do
        new_node = LinkedNode.new('hey', LinkedNode.new('my guy'))
        list = LinkedList.new(new_node)
        expect(list.tail).to be_truthy
      end
      it 'correctly assigns the tail pointer when a node with many next nodes is passed in' do
        new_node = LinkedNode.new('hey', LinkedNode.new('my guy', LinkedNode.new('my guy', LinkedNode.new('tail'))))
        list = LinkedList.new(new_node)
        expect(list.tail.data).to eq('tail')
      end
      it 'makes the tail the head when a list with only one node is created' do
        new_node = LinkedNode.new('head')
        list = LinkedList.new(new_node)
        expect(list.head).to equal(list.tail)
      end
    end
  end
  describe '#append' do
    it 'works with a nil head' do
      list = LinkedList.new
      new_node = LinkedNode.new('head')
      list.append(new_node)
      expect(list.head.data).to eq('head')
    end
    it 'adds a node to the end of the list' do
      head = LinkedNode.new('head')
      list = LinkedList.new(head)
      tail = LinkedNode.new('tail')
      list.append(tail)
      expect(list.tail).to equal(tail)
    end
    it 'correctly assigns the tail pointer when appending a node with next node(s)' do
      head = LinkedNode.new('head')
      list = LinkedList.new(head)
      mid = LinkedNode.new('mid',LinkedNode.new('tail'))
      list.append(mid)
      expect(list.tail.data).to eq('tail')
    end
  end
  describe '#find' do
    it 'returns nil when the head is nil' do
      list = LinkedList.new
      expect(list.find('not present')).to be nil
    end
    it 'finds a node with a passed value' do
      new_node = LinkedNode.new('A', LinkedNode.new('B', LinkedNode.new('C', LinkedNode.new('D'))))
      list = LinkedList.new(new_node)
      expect((list.find('C')).data).to eq('C')
    end
    it 'returns nil when the passed value is not present' do
      new_node = LinkedNode.new('A', LinkedNode.new('B', LinkedNode.new('C', LinkedNode.new('D'))))
      list = LinkedList.new(new_node)
      expect((list.find('E'))).to be nil
    end
  end
  describe '#size' do
    it 'returns 0 when the list is empty' do
      list = LinkedList.new
      expect(list.size).to eql(0)
    end
    it 'returns 1 when the list only has the head' do
      head = LinkedNode.new('head')
      list = LinkedList.new(head)
      expect(list.size).to eql(1)
    end

    it 'returns 2 when the list has two nodes' do
      head = LinkedNode.new('one', LinkedNode.new('two'))
      list = LinkedList.new(head)
      expect(list.size).to eql(2)
    end
    it 'returns 3 when the list has three nodes' do
      head = LinkedNode.new('one', LinkedNode.new('two', LinkedNode.new('three')))
      list = LinkedList.new(head)
      expect(list.size).to eql(3)
    end
    it 'returns 4 when the list has four nodes' do
      head = LinkedNode.new('one', LinkedNode.new('two', LinkedNode.new('three', LinkedNode.new('four'))))
      list = LinkedList.new(head)
      expect(list.size).to eql(4)
    end
  end
end

describe PositionNode do
  describe 'the data it holds' do
    it 'holds the position data for itself' do
      new_node = PositionNode.new('position')
      expect(new_node).to be_truthy
    end
    it 'holds an adjacency list' do
      new_node = PositionNode.new('position')
      new_node.adjacency_list = LinkedList.new
      expect((new_node.adjacency_list).is_a? LinkedList).to be true
    end
    it 'only allows a linked list to be passed for the adjacency list' do
      new_node = PositionNode.new('position', 'false list')
      expect((new_node.adjacency_list).is_a? LinkedList).to be true
    end
    it 'holds the symbol occupying the node' do
      new_node = PositionNode.new('position')
      new_node.occupant = 'B'
      expect(new_node.occupant).to eq('B')
    end
  end
end

describe Graph do
  describe 'the data it holds' do
    it 'holds a linked list as the list' do
      graph = Graph.new
      expect(graph.list.is_a? LinkedList).to be true
    end
  end
end

describe Board do
  describe 'the data it holds' do
    describe 'the graph it holds' do
      it 'holds a graph' do
        board = Board.new
        expect(board.graph.is_a?(Graph)).to be true
      end
      it 'holds (7 by 6) 42 nodes in total' do
        board = Board.new
        expect(board.graph.list.size).to eql(42)
      end
      it '(the board) is 7 nodes horizontally and 6 nodes vertically' do
        board = Board.new
        head = board.graph.list.head
        tail = board.graph.list.tail
        expect(head.data.position).to eql([1, 6])
        expect(tail.data.position).to eql([7, 1])
      end
    end
  end
  describe '#display' do
    it 'displays the graph in a format the users can visualise' do
      board = Board.new
      board.display
    end
  end
  describe '#occupy' do
    it 'takes a symbol, a column and occupies a slot' do
      board = Board.new
      column = 1
      symbol = 'o'
      board.occupy(column, symbol)
      node_to_occupy = nil
      nodes = board.graph.list.traverse
      nodes.each do |node|
        node_to_occupy = node if node.data.position[1] == column
      end
      expect(node_to_occupy.data.occupant).to eql(['o'])
    end
    it 'doesnt override an existing slot' do
      board = Board.new
      column = 1
      symbol = 'o'
      board.occupy(column, symbol)
      node_to_occupy = nil
      nodes = board.graph.list.traverse
      nodes.each do |node|
        node_to_occupy = node if node.data.position[1] == column
      end
      board.occupy(column, symbol)
      board.occupy(column, symbol)
      board.occupy(column, symbol)
      board.display
    end
  end
end
