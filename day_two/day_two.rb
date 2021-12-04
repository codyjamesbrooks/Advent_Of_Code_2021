file = File.open('input.txt')
instructions = file.readlines.map {|line| line.chomp.split }
p instructions.length

# Part One
class Instruction 
  attr_reader :direction, :magnitude
  def initialize( instruction_string )
    @direction = instruction_string.first
    @magnitude = instruction_string.last.to_i    
  end 
end 

instruction_objects = instructions.map { |s| Instruction.new(s) }

class Submarine
  attr_accessor :x_coord, :depth
  def initialize
    @x_coord = 0
    @depth  = 0
  end

  def move_sub( instruction )
    case instruction.direction
    when 'forward'
      @x_coord += instruction.magnitude
    when 'down'
      @depth += instruction.magnitude
    when 'up'
      @depth -= instruction.magnitude
    end 
  end 

  def follow_instructions( instructions_objects )
    instructions_objects.each { |instruction| move_sub(instruction) }
  end 
end 

elves_sub = Submarine.new
elves_sub.follow_instructions(instruction_objects)
answer = elves_sub.x_coord * elves_sub.depth
puts "The answer to part one is #{answer}"

# Part Two

class AimedSubmarine < Submarine
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
      @x_coord += instruction.magnitude
      @depth += @aim * instruction.magnitude
    end 
  end 
end

aimmed_elf_sub = AimedSubmarine.new
aimmed_elf_sub.follow_instructions(instruction_objects)
answer2 = aimmed_elf_sub.x_coord * aimmed_elf_sub.depth
puts "The answer to part two is #{answer2}"




# Craveing a shorter solution.
sub_pos = { x_pos: 0, depth: 0 } 
instructions.each do |dir, delta|
  case dir
  when 'forward' then sub_pos[:x_pos] += delta.to_i
  when 'up'      then sub_pos[:depth] -= delta.to_i
  when 'down'    then sub_pos[:depth] += delta.to_i
  end
end
puts "the answer to part one is #{sub_pos[:x_pos] * sub_pos[:depth]}"

# Part Two
aimed_sub_pos = { x_pos: 0, depth: 0, aim: 0 }
instructions.each do |dir, delta|
  case dir
  when 'up'      then aimed_sub_pos[:aim] -= delta.to_i
  when 'down'    then aimed_sub_pos[:aim] += delta.to_i
  when 'forward'
    aimed_sub_pos[:x_pos] += delta.to_i
    aimed_sub_pos[:depth] += aimed_sub_pos[:aim] * delta.to_i
  end 
end 
puts "the answer to part two is #{aimed_sub_pos[:x_pos] * aimed_sub_pos[:depth]}"