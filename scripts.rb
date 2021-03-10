class LinkedNode
  attr_accessor :data, :next_node

  def initialize(data, next_node = nil)
    @data = data
    @next_node = next_node
  end

end

class LinkedList
  attr_accessor :head, :tail

  def initialize(head = nil)
    @head = head
    @tail = nil
    unless head.nil?
      @tail = @head
      until @tail.next_node.nil?
        @tail = @tail.next_node
      end
    end
  end

  def append(node)
    if @head.nil?
      @head = node
      @tail = @head
    else
      @tail.next_node = node
      until @tail.next_node.nil?
        @tail = @tail.next_node
      end
    end
  end

  def find(value)
    return nil if @head.nil?
    return @head if @head.data == value

    next_node = @head.next_node
    return next_node if next_node.data == value

    until next_node.nil?
      return next_node if next_node.data == value

      next_node = next_node.next_node
    end
  end

  def size
    return 0 if @head.nil?
    counter = 1
    next_node = @head.next_node
    until next_node.nil?
      next_node = next_node.next_node
      counter += 1
    end
    counter
  end

  def traverse
    nodes = []
    traversing = @head
    nodes.push(traversing)
    until traversing.next_node.nil?
      traversing = traversing.next_node
      nodes.push(traversing)
    end
    nodes
  end
end

class PositionNode
  attr_accessor :position, :adjacency_list, :occupant

  def initialize(position, adjacency_list = LinkedList.new)
    @position = position
    @adjacency_list = adjacency_list
    @adjacency_list = LinkedList.new unless adjacency_list.is_a? LinkedList
    @occupant = [' ']
  end
end

class Graph
  attr_accessor :list

  def initialize
    @list = LinkedList.new
  end

end

class Board
  attr_accessor :graph

  def initialize
    @graph = Graph.new
    populate_graph
  end

  def populate_graph
    horizontal_node_number = 7
    vertical_node_number = 6
    # horizontal_node_number.times do |i|
    #   vertical_node_number.times do |j|
    #     @graph.list.append(LinkedNode.new(PositionNode.new([i + 1, j + 1])))
    #   end
    # end

    vertical_node_number.downto(1) do |i|
      horizontal_node_number.times do |j|
        @graph.list.append(LinkedNode.new(PositionNode.new([j + 1, i])))
      end
    end
  end

  def display
    puts ''
    puts '------------------------------'
    nodes = @graph.list.traverse
    # nodes.reverse!
    vertical = 6
    nodes.each do |linked_node|
      if linked_node.data.position[1] == vertical
        print linked_node.data.position.to_s
      else
        print "\n"
        print linked_node.data.position.to_s
        vertical = linked_node.data.position[1]
      end
    end
  end

  def occupy(column, symbol)
    nodes = @graph.list.traverse
    node_to_occupy = nil
    nodes.each do |node|
      node_to_occupy = node if node.data.position[1] == column && node.data.occupant == [' ']
    end
    node_to_occupy.data.occupant = [symbol]
  end
end