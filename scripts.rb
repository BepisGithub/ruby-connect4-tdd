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
  attr_accessor :graph, :index_array

  def initialize
    @graph = Graph.new
    populate_graph
  end

  def populate_graph
    horizontal_node_number = 7
    @index_array = []
    horizontal_node_number.times do |i|
      @index_array.push((i + 1).to_s)
    end
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
    puts ''
    puts @index_array.to_s
    # puts ['1', '2', '3', '4', '5', '6', '7'].to_s
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
    # binding.pry
    # check each row at a time
    symbol = nodes_array[0].data.occupant
    counter = 0
    won = false
    right_node = {}
    left_node = {}

    nodes_array.each do |node|
      next if node.data.adjacency_list.empty?

      x_coord = node.data.position[0]
      y_coord = node.data.position[1]
      adjacent_nodes = node.data.adjacency_list.traverse
      adjacent_nodes.each do |adj_node|
        pos_adj_node = nodes_array.select{ |n| n.data.position == adj_node.data }
        pos_adj_node = pos_adj_node[0]
        unless pos_adj_node.nil?
          right_node[node] = pos_adj_node if pos_adj_node.data.position == [x_coord + 1, y_coord]
          left_node[node] = pos_adj_node if pos_adj_node.data.position == [x_coord - 1, y_coord]
        end
      end
      # binding.pry

    end

    nodes_array.each do |node|
      # binding.pry
      # check left or right
      if right_node[node]
        counter = 1
        right = right_node[node]
        counter += 1 unless right.nil?
        until right.nil?
          right = right_node[right]
          counter += 1 unless right.nil?
        end
        won = symbol if counter > 3
        break if counter > 3
      end
      if left_node[node]
        counter = 1
        left = left_node[node]
        counter += 1 unless left.nil?
        until left.nil?
          left = left_node[left]
          counter += 1 unless left.nil?
        end
        won = symbol if counter > 3
        break if counter > 3
      end
    end
    return won



    # rows.each do |row_number, nodes_on_row|
    #   next if nodes_on_row.size < 4
    #   counter = 0
    #   nodes_on_row.each do |node|
    #     next if node.data.adjacency_list.empty?

    #     adjacent_nodes = node.data.adjacency_list.traverse
    #     y_coord = node.data.position[1]
    #     horizontal_adjacent_nodes = adjacent_nodes.select { |node| node.data[1] == y_coord }
    #     next if horizontal_adjacent_nodes.empty?

    #     counter += 1
    #   end
    # end
    # return symbol if counter == 4

    # false
  end

  def vertical_won?(nodes_array)
    return false if nodes_array.empty?
    # check each row at a time
    symbol = nodes_array[0].data.occupant
    counter = 0
    won = false
    top_node = {}
    bottom_node = {}

    nodes_array.each do |node|
      next if node.data.adjacency_list.empty?

      x_coord = node.data.position[0]
      y_coord = node.data.position[1]
      adjacent_nodes = node.data.adjacency_list.traverse
      adjacent_nodes.each do |adj_node|
        pos_adj_node = nodes_array.select{ |n| n.data.position == adj_node.data }
        pos_adj_node = pos_adj_node[0]
        unless pos_adj_node.nil?
          top_node[node] = pos_adj_node if pos_adj_node.data.position == [x_coord, y_coord + 1]
          bottom_node[node] = pos_adj_node if pos_adj_node.data.position == [x_coord, y_coord - 1]
        end
      end
    end

    nodes_array.each do |node|
      # check left or right
      if top_node[node]
        counter = 1
        top = top_node[node]
        counter += 1 unless top.nil?
        until top.nil?
          top = top_node[top]
          counter += 1 unless top.nil?
        end
        won = symbol if counter > 3
        break if counter > 3
      end
      if bottom_node[node]
        counter = 1
        bottom = bottom_node[node]
        counter += 1 unless bottom.nil?
        until bottom.nil?
          bottom = bottom_node[bottom]
          counter += 1 unless bottom.nil?
        end
        won = symbol if counter > 3
        break if counter > 3
      end
    end
    return won
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
      end
      if top_left_adjacent_nodes[node]
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
      end
      if bottom_right_adjacent_nodes[node]
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
      end
      if bottom_left_adjacent_nodes[node]
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
    # TODO: CALL THE WON FUNCTIONS
    return diagonal_won?(first_player_nodes) if diagonal_won?(first_player_nodes)
    return horizontal_won?(first_player_nodes) if horizontal_won?(first_player_nodes)
    return vertical_won?(first_player_nodes) if vertical_won?(first_player_nodes)

    return diagonal_won?(second_player_nodes) if diagonal_won?(second_player_nodes)
    return horizontal_won?(second_player_nodes) if horizontal_won?(second_player_nodes)
    return vertical_won?(second_player_nodes) if vertical_won?(second_player_nodes)

    false

  end
end

class Player
  attr_accessor :name, :won, :active, :symbol

  def initialize(name, symbol = 'NIL SYMBOL')
    @name = name
    @won = false
    @active = false
    @symbol = symbol
  end
end

class Game
  attr_accessor :player_one, :player_two, :board

  def initialize
    @board = Board.new
    puts 'What is the name of player one? :'
    name_one = gets.strip.chomp.to_s
    symbol_one = 'o'
    @player_one = Player.new(name_one, symbol_one)
    puts 'What is the name of player two? :'
    name_two = gets.strip.chomp.to_s
    symbol_two = 'x'
    @player_two = Player.new(name_two, symbol_two)
    puts "The symbol of #{@player_one.name} is #{@player_one.symbol} and the symbol of #{@player_two.name} is #{@player_two.symbol}"
  end

  def get_column_choice(active_player)
    puts "What is your column choice, #{active_player.name}? Your symbol is #{active_player.symbol}. The choices are between 1 to 7"
    column_choice = gets.strip.chomp.to_i
    until column_choice > 0 && column_choice <= 7
      puts 'Your choice must be an integer with a maximum value of 7'
      column_choice = gets.strip.chomp.to_i
    end
    column_choice
  end

  def play
    rand_num = rand(1..10)
    rand_num % 2 ? @player_one.active = true : @player_two.active = true
    active_player = -1
    result = @board.won?
    @board.display
    until result
      # one of the players is active
      @player_one.active == true ? active_player = @player_one : active_player = @player_two
      column_choice = get_column_choice(active_player)
      occupy_attempt = @board.occupy(column_choice, active_player.symbol)
      until occupy_attempt != 'error: column full'
        puts occupy_attempt
        column_choice = get_column_choice(active_player)
        occupy_attempt = @board.occupy(column_choice, active_player.symbol)
      end
      @board.display
      result = @board.won?
      @player_one.active = !(@player_one.active)
      @player_two.active = !(@player_two.active)
    end
    # the game is over and the result variable holds the symbol of the winner
    winner = -1
    [@player_one.symbol] == result ? winner = @player_one : winner = @player_two
    winner.won = true
    puts "Congratulations, #{winner.name}, your symbol was #{winner.symbol} and you won!"
  end

end