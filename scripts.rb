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

end