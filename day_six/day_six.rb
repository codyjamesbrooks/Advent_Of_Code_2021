file = File.open('input.txt')
data = file.read.split(',').map(&:to_i)

# test_data = [3,4,3,1,2]
# data = [3,4,1,2,1,2,5,1,2,1,5,4,3,2,5,1,5,1,2,2,2,3,4,5,2,5,1,3,3,1,3,4,1,5,3,2,2,1,3,2,5,1,1,4,1,4,5,1,3,1,1,5,3,1,1,4,2,2,5,1,5,5,1,5,4,1,5,3,5,1,1,4,1,2,2,1,1,1,4,2,1,3,1,1,4,5,1,1,1,1,1,5,1,1,4,1,1,1,1,2,1,4,2,1,2,4,1,3,1,2,3,2,4,1,1,5,1,1,1,2,5,5,1,1,4,1,2,2,3,5,1,4,5,4,1,3,1,4,1,4,3,2,4,3,2,4,5,1,4,5,2,1,1,1,1,1,3,1,5,1,3,1,1,2,1,4,1,3,1,5,2,4,2,1,1,1,2,1,1,4,1,1,1,1,1,5,4,1,3,3,5,3,2,5,5,2,1,5,2,4,4,1,5,2,3,1,5,3,4,1,5,1,5,3,1,1,1,4,4,5,1,1,1,3,1,4,5,1,2,3,1,3,2,3,1,3,5,4,3,1,3,4,3,1,2,1,1,3,1,1,3,1,1,4,1,2,1,2,5,1,1,3,5,3,3,3,1,1,1,1,1,5,3,3,1,1,3,4,1,1,4,1,1,2,4,4,1,1,3,1,3,2,2,1,2,5,3,3,1,1]

# Solution
class HashOfFishAges 
  attr_accessor :ages
  def initialize( fish_ages )
    @fish_at_age = (0..8).to_a.to_h {|age| [age, fish_ages.count(age)] }
  end 
  
  def grow_old 
    new_borns = @fish_at_age[0]                      # All of the 0-year old fish spawn a new born.
    @fish_at_age.transform_keys! { |age| age - 1 }   # All of the fish age one year.
    @fish_at_age.select! {|age, _| age >= 0 }        # All of the 0-year fish are fade to ash.
    @fish_at_age[6] += new_borns                     # All of the 0-year fish are reborn as 6-year olds.
    @fish_at_age[8] = new_borns                      # All the new borns hatch. 
  end 

  def grow_n_days( n )
    n.times { |_| grow_old }
  end 

  def population
    @fish_at_age.reduce(0) { |total, (age, count)| total + count }
  end 
end 

fishPopulation = HashOfFishAges.new(data)
fishPopulation.grow_n_days(80)
puts "after 80 days the population grows to #{fishPopulation.population}"

fishPopulation.grow_n_days(176)
puts "after 256 days the population grows to #{fishPopulation.population}"

# Annnnd if you care to ready more. This will hopefully give you a chuckle
# Below is my inital. Solution. Pretty rough way of solving the dang thing.
# But kind of a funny.
# And I would have gotten with the below crumby chunk of code if 
# It wasn't for Part Two. 
# Where I realized that I was asking my computer to remember the 
# birthdays of +26 billion different fish. 
# And it replied by saying... "No."
# 
# And that was using the test data set


class LanternFish
  attr_accessor :age, :new_born
  def initialize(age=8, new_born=true)
    @age = age 
    @new_born = new_born
  end 

  def grow_old
    if @new_born
      @new_born = false
    else 
      @age = @age > 0 ? @age - 1 : 6 
    end 
  end
end 
 
class SchoolOfFish
  attr_accessor :population, :school
  def initialize( fish_ages )
    @school = fish_ages.map {|age| LanternFish.new(age, false) }
    @days = 0
  end 

  def grow_old
    @days += 1
    reproduce
    @school.each {|fish| fish.grow_old }
  end 

  def reproduce
    new_borns = @school.select { |fish| fish.age == 0 }.count 
    @school = @school.concat(Array.new(new_borns) { LanternFish.new } )
  end

  def ages 
    @school.map { |fish| fish.age }.join(', ')
  end 

  def grow_n_days( n )
    n.times { |_| grow_old }
  end 

  def population 
    @school.count
  end 
end 


# Part One
# school_of_fish_p1 = SchoolOfFish.new(data)
# school_of_fish_p1.grow_n_days(80)
# answer = school_of_fish_p1.population
# puts "The answer to part one is #{answer}"


# Part Two
# school_of_fish_p2 = SchoolOfFish.new(data)
# school_of_fish_p2.grow_n_days(176)
# answer = school_of_fish_p2.population
# puts "Yeah right you fool. Aint no way im making that calculation...."
