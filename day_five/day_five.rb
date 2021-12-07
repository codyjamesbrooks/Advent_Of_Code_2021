file = File.open('input.txt')
data = file.readlines
            .map(&:chomp)
            .map { |v| v.split(' -> ') }

class Pipe
  attr_accessor :start, :end
  def initialize( coords )
    @start = coords.first.split(',').map(&:to_i)
    @end   = coords.last.split(',').map(&:to_i)
  end 
  
  def to_s
    "#{@start.join(',')} -> #{@end.join(',')}"
  end

  def plot
    line  = [@start]
    delta = direction
    1.upto(length) do |i| 
      diff = delta.map { |cord| cord * i }
      line << [@start, diff].transpose.map { |x| x.reduce(&:+) }
    end 
    line
  end 

  def length
    @end.zip(@start).map { |x| x.reduce(&:-).abs }.max
  end 

  def horizontal_or_vertical?
    (@start.first == @end.first ||
    @start.last  == @end.last    )
  end 

  def direction
    change = @end.zip(@start).map {|change| change.reduce(&:-) }
    change.map {|diff| diff != 0 ? diff / diff.abs : 0 }
  end
end 

class OceanFloor
  attr_accessor :grid
  def initialize
    @grid = Hash.new(0)
  end 

  def plot_pipe( pipe )
    pipe.plot.each do |coord|
      @grid[coord] += 1
    end 
  end

  def plot_horz_vert_or_diag_pipes(pipe_array)
    pipe_array.each { |pipe| plot_pipe(pipe) }
  end 

  def plot_horz_or_vertical_pipes( pipe_array )
    pipe_array.each { |pipe| plot_pipe(pipe) if pipe.horizontal_or_vertical? }
  end 
end 

all_pipes = data.map { |pipe_string| Pipe.new(pipe_string) }
p1_pipe_map = OceanFloor.new
p1_pipe_map.plot_horz_or_vertical_pipes(all_pipes)
answer =  p1_pipe_map.grid.select { |point, intersect| point if intersect > 1 }.count
puts "The answer to part one is #{answer}"

# Part Two

p2_pipe_map = OceanFloor.new
p2_pipe_map.plot_horz_vert_or_diag_pipes(all_pipes)
answer = p2_pipe_map.grid.select { |point, intersect| point if intersect > 1 }.count
puts "The answer to part two is #{answer}"