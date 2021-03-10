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

    counter
  end
end

class PositionNode
  attr_accessor :position, :adjacency_list

  def initialize(position, adjacency_list = LinkedList.new)
    @position = position
    @adjacency_list = adjacency_list
    @adjacency_list = LinkedList.new unless adjacency_list.is_a? LinkedList
  end
end