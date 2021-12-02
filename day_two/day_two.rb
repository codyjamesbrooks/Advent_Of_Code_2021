file = File.open('input.txt')
instructions = file.readlines.map(&:chomp)

class ElvesSubmarine
  attr_accessor :horizontal, :depth
  def initialize
    @horizontal = 0
    @depth      = 0
  end

  def move_sub( instruction )
    case instruction.direction
    when 'forward'
      @horizontal += instruction.magnitude
    when 'down'
      @depth += instruction.magnitude
    when 'up'
      @depth -= instruction.magnitude
    end 
  end 
end 

class Instruction 
  attr_reader :direction, :magnitude
  def initialize( instruction_string )
    @direction = instruction_string.split.first
    @magnitude = instruction_string.split.last.to_i    
  end 
end 


# Part One
elves_sub = ElvesSubmarine.new
instructions.each do |instruction_string|
  elves_sub.move_sub(Instruction.new(instruction_string))
end 

puts "After following all instructions"
puts "The elves sub has moved forward #{elves_sub.horizontal} units"
puts "And the sub is #{elves_sub.depth} units deep"
answer = elves_sub.horizontal * elves_sub.depth
puts "The answer to part one is #{answer}", ""

# Part Two

class AimedElvesSubmarine < ElvesSubmarine
  attr_accessor :aim
  def initialize
    super
    @aim = 0
  end 

  def move_sub( instruction )
    case instruction.direction
    when "down"
      @aim += instruction.magnitude
    when "up"
      @aim -= instruction.magnitude
    when "forward"
      @horizontal += instruction.magnitude
      @depth += @aim * instruction.magnitude
    end 
  end 
end

aimed_elves_sub = AimedElvesSubmarine.new
instructions.each do |instruction_string|
  aimed_elves_sub.move_sub(Instruction.new(instruction_string))
end 
puts "Taking into effect the elves newfound ability to aim the sub"
puts "The elves sub has moved forward #{aimed_elves_sub.horizontal} units"
puts "And the sub is #{aimed_elves_sub.depth} units deep"
answer = aimed_elves_sub.horizontal * aimed_elves_sub.depth
puts "The answer to part two is #{answer}", ""
