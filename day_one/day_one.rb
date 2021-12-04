file   = File.open('input.txt')
depths = file.readlines.map(&:to_i)

def times_array_increases_by_index( array )
  increased = array[1..].select.with_index { |value, prev_index| value > array[prev_index] }
  increased.length
end 

# Part One
# Above method will determine how many times array[i] > array[i-1]
depth_increases = times_array_increases_by_index(depths)
puts "the answer to part one is #{depth_increases}"

# Part Two 
# For part two we can use the same method, we simply need to pass in a different array
depth_groups = depths[0..-3].map.with_index { |_, index| depths[index, 3].sum }

depth_group_increases = times_array_increases_by_index(depth_groups)
puts "The answer to part two is #{depth_group_increases}"


answer = depths.each_cons(2).select { |a, b| b > a }.length
puts "The answer to part one is #{answer}"