module Enumerable
  # Your code goes here
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    return to_enum(:my_each) unless block_given?

    self.each do |key, value|
      yield key, value
    end
  end
  
  # Some trouble getting the right result in my_each_with_index

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    self.each_with_index do |value, index|
      yield self[index], value
    end
  end

  def my_select(&block)
    return to_enum(:my_select) unless block_given?

    array = []
    hash = {}

    case self
    when Array
      self.my_each { |item| array.push(item) if block.call(item) }
      return array
    when Hash
      self.my_each { |key, value| hash[key] = value if block.call(key, value) }
      hash
    end
  end

  def my_all?(argv=nil, &block)
    block = Proc.new { |item| item unless item.nil? || !item } unless block_given?
    block = Proc.new { |item| item if argv === item} unless argv.nil?
    self.my_each { |item| return false unless block.call(item) }
    
    true
  end

  def my_any?(argv=nil, &block)
    block = Proc.new { |item| item unless item.nil? || !item } unless block_given?
    block = Proc.new { |item| item if argv === item} unless argv.nil?
    self.my_each { |item| return true if block.call(item)}

    false
  end

  def my_none?(argv=nil, &block)
    block = Proc.new { |item| item unless item.nil? || !item } unless block_given?
    block = Proc.new { |item| item if argv === item} unless argv.nil?
    self.my_each { |item| return false if block.call(item)}

    true
  end

  def my_count(argv = nil, &block)
    count = 0
    return self.size if !block_given? && argv.nil?
    
    block = Proc.new { |item| item if argv == item } unless argv.nil?
    self.my_each { |item| count += 1 if block.call(item) }
    count
  end

  def my_map(a_proc = nil)
    arr = []
    if a_proc
      self.my_each { |item| arr.push(a_proc.call(item)) }
      return arr
    end
    self.my_each { |item| arr.push(yield item) }
    arr
  end

  def my_inject(accumulator = nil, &block)
    self.class == Range ? array = self.to_a : array = self
    if block_given?
      if accumulator.nil?
        accumulator = self.first
        array.each_with_index do |value, index|
          accumulator = block.call(accumulator, array[index + 1])
        end
      elsif accumulator
        array.each_with_index do |value, index|
          accumulator = block.call(accumulator, array[index])
        end

      end
    end
    accumulator
  end

end
