class LinkedNode
  attr_accessor :data, :next_node

  def initialize(data, next_node = nil)
    @data = data
    @next_node = next_node
  end

end

class LinkedList
  attr_accessor :head, :tail

  def initialize(head)
    @head = head
    @tail = @head
    until @tail.next_node.nil?
      @tail = @tail.next_node
    end
  end

  def append(node)
    @tail.next_node = node
    until @tail.next_node.nil?
      @tail = @tail.next_node
    end
  end

  def find(value)
    return @head if @head.data == value
    next_node = @head.next_node
    return next_node if next_node.data == value
    until next_node.nil?
      return next_node if next_node.data == value
      next_node = next_node.next_node
    end
  end

end