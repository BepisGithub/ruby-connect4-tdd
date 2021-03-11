require 'pry'

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

  def empty?
    return true if @head.nil?
    false
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
    return 'error: column full' if node_to_occupy.nil?

    node_to_occupy.data.occupant = [symbol]
    populate_adjacency_list
  end

  def horizontal_won?(nodes_array)
    return false if nodes_array.empty?
    # check each row at a time
    symbol = nodes_array[0].data.occupant
    counter = 0
    rows = {}
    6.times do |i|
      rows[i + 1] = nodes_array.select { |node| node.data.position[1] == (i + 1) }
    end
    rows.each do |row_number, nodes_on_row|
      next if nodes_on_row.size < 4

      counter = 0
      nodes_on_row.each do |node|
        next if node.data.adjacency_list.empty?

        adjacent_nodes = node.data.adjacency_list.traverse
        y_coord = node.data.position[1]
        horizontal_adjacent_nodes = adjacent_nodes.select { |node| node.data[1] == y_coord }
        next if horizontal_adjacent_nodes.empty?

        counter += 1
      end
    end
    return symbol if counter == 4

    false
  end

  def vertical_won?(nodes_array)
    return false if nodes_array.empty?

    symbol = nodes_array[0].data.occupant
    counter = 0
    columns = {}
    7.times do |i|
      columns[i + 1] = nodes_array.select { |node| node.data.position[0] == (i + 1) }
    end
    columns.each do |column_number, nodes_on_column|
      next if nodes_on_column.size < 4

      counter = 0
      nodes_on_column.each do |node|
        next if node.data.adjacency_list.empty?

        adjacent_nodes = node.data.adjacency_list.traverse
        x_coord = node.data.position[0]
        vertical_adjacent_nodes = adjacent_nodes.select { |node| node.data[0] == x_coord }
        next if vertical_adjacent_nodes.empty?

        counter += 1
      end
    end
    return symbol if counter == 4

    false
  end

  def diagonal_won?(nodes_array)
    return false if nodes_array.empty?
    symbol = nodes_array[0].data.occupant
    counter = 0
    top_right_adjacent_nodes = {}
    top_left_adjacent_nodes = {}
    bottom_right_adjacent_nodes = {}
    bottom_left_adjacent_nodes = {}


    nodes_array.each do |node|
      next if node.data.adjacency_list.empty?

      adjacent_nodes = node.data.adjacency_list.traverse
      x_coord = node.data.position[0]
      y_coord = node.data.position[1]
      adjacent_nodes.each do |adj_node|
        # some adjacent nodes are constantly being reevaluated by this method
        # include some sort of check to not recheck already done nodes

        top_left_adjacent_nodes[node] = adj_node if adj_node.data == [x_coord - 1, y_coord + 1]
        top_right_adjacent_nodes[node] = adj_node if adj_node.data == [x_coord + 1, y_coord + 1]
        bottom_right_adjacent_nodes[node] = adj_node if adj_node.data == [x_coord + 1, y_coord - 1]
        bottom_left_adjacent_nodes[node] = adj_node if adj_node.data == [x_coord - 1, y_coord - 1]
      end

    end

    nodes_array.each do |node|
      if top_right_adjacent_nodes[node]
        counter = 1
        top_right = top_right_adjacent_nodes[node]
        counter += 1
        until top_right.nil?
          # THE ISSUE LIES IN MAKING THE TOP RIGHT A LINKED ADJ NODE
          # BUT THE HASHES CONTAIN THE LINKED POSITION NODES AS THE KEY
          # we need to find the linked position node with the corresponding value
          top_right = nodes_array.select { |node| node.data.position == top_right.data}
          top_right = top_right[0]
          top_right = top_right_adjacent_nodes[top_right]
          counter += 1 unless top_right.nil?
        end
        return symbol if counter > 3
      elsif top_left_adjacent_nodes[node]
        counter = 1
        top_left = top_left_adjacent_nodes[node]
        counter += 1
        until top_left.nil?
          top_left = nodes_array.select { |node| node.data.position == top_left.data }
          top_left = top_left[0]
          top_left = top_left_adjacent_nodes[top_left]
          counter += 1 unless top_left.nil?
        end
        return symbol if counter > 3
      elsif bottom_right_adjacent_nodes[node]
        counter = 1
        bottom_right = bottom_right_adjacent_nodes[node]
        counter += 1
        until bottom_right.nil?
          bottom_right = nodes_array.select { |node| node.data.position == bottom_right.data }
          bottom_right = bottom_right[0]
          bottom_right = bottom_right_adjacent_nodes[bottom_right]
          counter += 1 unless bottom_right.nil?
        end
        return symbol if counter > 3
        
      elsif bottom_left_adjacent_nodes[node]
        counter = 1
        bottom_left = bottom_left_adjacent_nodes[node]
        counter += 1
        until bottom_left.nil?
          bottom_left = nodes_array.select { |node| node.data.position == bottom_left.data }
          bottom_left = bottom_left[0]
          bottom_left = bottom_left_adjacent_nodes[bottom_left]
          counter += 1 unless bottom_left.nil?
        end
        return symbol if counter > 3
      end
    end

    false

    # nodes_array.each do |node|
    #   # possibilites are
    #   # node has NO adjacent nodes -> next (done)
    #   # node has ONE adjacent node -> follow along that direction ONLY -> return the symbol once the counter hits 4
    #   # node has MORE THAN ONE adjacent node -> follow along each -> if at any point the counter hits 4 then return the symbol
    #   directions = 0
    #   directions += 1 unless top_right_adjacent_nodes[node].nil?
    #   directions += 1 unless top_left_adjacent_nodes[node].nil?
    #   directions += 1 unless bottom_right_adjacent_nodes[node].nil?
    #   directions += 1 unless bottom_left_adjacent_nodes[node].nil?

    #   counter = 0 # if directions.zero?
    #   next if directions.zero?

    #   if directions == 1
    #     # follow along the direction
    #     if top_right_adjacent_nodes[node]
    #       counter += 1
    #       top_right = top_right_adjacent_nodes[node]
    #       while top_right_adjacent_nodes[top_right]
    #         top_right = top_right_adjacent_nodes[top_right]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     elsif top_left_adjacent_nodes[node]
    #       counter += 1
    #       top_left = top_left_adjacent_nodes[node]
    #       while top_left_adjacent_nodes[top_left]
    #         top_left = top_left_adjacent_nodes[top_left]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     elsif bottom_right_adjacent_nodes[node]
    #       counter += 1
    #       bottom_right = bottom_right_adjacent_nodes[node]
    #       while bottom_right_adjacent_nodes[bottom_right]
    #         bottom_right = bottom_right_adjacent_nodes[bottom_right]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     elsif bottom_left_adjacent_nodes[node]
    #       counter += 1
    #       bottom_left = bottom_left_adjacent_nodes[node]
    #       while bottom_left_adjacent_nodes[bottom_left]
    #         bottom_left = bottom_left_adjacent_nodes[bottom_left]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     end
    #   else
    #     if top_right_adjacent_nodes[node]
    #       counter += 1
    #       top_right = top_right_adjacent_nodes[node]
    #       while top_right_adjacent_nodes[top_right]
    #         top_right = top_right_adjacent_nodes[top_right]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     elsif top_left_adjacent_nodes[node]
    #       counter += 1
    #       top_left = top_left_adjacent_nodes[node]
    #       while top_left_adjacent_nodes[top_left]
    #         top_left = top_left_adjacent_nodes[top_left]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     elsif bottom_right_adjacent_nodes[node]
    #       counter += 1
    #       bottom_right = bottom_right_adjacent_nodes[node]
    #       while bottom_right_adjacent_nodes[bottom_right]
    #         bottom_right = bottom_right_adjacent_nodes[bottom_right]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     elsif bottom_left_adjacent_nodes[node]
    #       counter += 1
    #       bottom_left = bottom_left_adjacent_nodes[node]
    #       while bottom_left_adjacent_nodes[bottom_left]
    #         bottom_left = bottom_left_adjacent_nodes[bottom_left]
    #         counter += 1
    #       end
    #       return symbol if counter > 3
    #     end
    #   end
    #   counter += 1
    # end
    # return symbol if counter > 3

    # false
  end

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

class Player
  attr_accessor :name, :won, :active

  def initialize(name)
    @name = name
    @won = false
    @active = false
  end
end