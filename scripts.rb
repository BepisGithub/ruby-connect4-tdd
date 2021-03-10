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

  def occupied_nodes
    return [] if @head.nil?
    nodes = traverse
    nodes.reject! { |node| node.data.occupant == [' '] }
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

  def populate_adjacency_list
    occupied_nodes = @graph.list.occupied_nodes
    occupied_nodes.each do |node|
      # each node here is a linked node holding a position node
      # the position node must have its adjacency list updated
      # the list will be updated with a linked node holding coords, NOT another position node
      # the adjacent nodes are the nodes whose coordinates do NOT differ by more than one
      coords = node.data.position
      x_coord = coords[0]
      y_coord = coords[1]
      # possibilites :
      # x - 1 y + 0
      potential_position_array = [x_coord - 1, y_coord]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x + 1 y + 0
      potential_position_array = [x_coord + 1, y_coord]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x + 0 y - 1
      potential_position_array = [x_coord, y_coord - 1]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x + 0 y + 1
      potential_position_array = [x_coord, y_coord + 1]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x + 1 y + 1
      potential_position_array = [x_coord + 1, y_coord + 1]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x - 1 y - 1
      potential_position_array = [x_coord - 1, y_coord - 1]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x + 1 y - 1
      potential_position_array = [x_coord + 1, y_coord - 1]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
      # x - 1 y - 1
      potential_position_array = [x_coord + 1, y_coord - 1]
      # need to check if this position is present in the occupied nodes
      present = occupied_nodes.select { |node| node.data.position == potential_position_array}
      node.data.adjacency_list.append(LinkedNode.new(potential_position_array)) unless present[0].nil?
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
        print linked_node.data.occupant.to_s
      else
        print "\n"
        print linked_node.data.occupant.to_s
        vertical = linked_node.data.position[1]
      end
    end
  end

  def occupy(column, symbol)
    nodes = @graph.list.traverse
    node_to_occupy = nil
    nodes.each do |node|
      node_to_occupy = node if node.data.position[0] == column && node.data.occupant == [' ']
    end
    node_to_occupy.data.occupant = [symbol]
  end

  # def horizontal_won?(nodes_array)
  #   # check each row at a time
  #   rows = {}
  #   6.times do |i|
  #     rows[i + 1] = nodes_array.select { |node| node.data.position[1] == (i + 1)}
  #   end
  #   rows.each do |row, nodes_on_row|
  #     next if nodes_on_row.size < 4

  #   end
  # end

  def won?
    occupied_nodes = @graph.list.occupied_nodes
    return false if occupied_nodes.empty?

    first_player_symbol = occupied_nodes[0].data.occupant
    first_player_nodes = []
    second_player_symbol = nil
    second_player_nodes = []
    occupied_nodes.each do |node|
      if node.data.occupant == first_player_symbol
        first_player_nodes.push(node)
      else
        second_player_symbol = node.data.occupant if second_player_symbol.nil?
        second_player_nodes.push(node)
      end
    end
    return false if first_player_nodes.size < 4 && second_player_nodes.size < 4


  end
end