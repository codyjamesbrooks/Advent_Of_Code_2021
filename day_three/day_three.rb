file = File.open('input.txt')
data = file.readlines.map { |x| x.chomp.to_s }
p data.first(10)
def group_strings_on_index( string_array )
  strings_brokedown = string_array.map(&:chars)
  strings_brokedown.first.zip(*strings_brokedown[1..])
end 

indexed_groupings = group_strings_on_index(data.first(10))
p indexed_groupings

def most_comon_character( array )
  array.group_by { |char| char.itself }
       .transform_values(&:size) 
       .max_by{ |_, v| v }
       .first
end 


most_common_character_by_index = indexed_groupings.map { |index_group| most_comon_character(index_group) }
gamma_rate = most_common_character_by_index.join.to_i(2)

least_common_character_by_index = most_common_character_by_index.map {|value| value == "0" ? "1" : "0" }
epsilon_rate = least_common_character_by_index.join.to_i(2)

answer = gamma_rate * epsilon_rate
puts "the asnwer to part one is #{answer}"

# Part two. 
# Uggh the way I solve nuber one doesn't exacly lend its self to number two. 

def char_counts( array )
  array.group_by(&:itself).transform_values(&:size)
end 

   
def oxygen_generator_rating(number_array)
  only_most_common = number_array.clone
  index = 0

  until only_most_common.length == 1
    grouped_on_index = group_strings_on_index(only_most_common)
    char_counts_at_index = char_counts(grouped_on_index[index])
    if char_counts_at_index['0'] == char_counts_at_index['1']
      only_most_common.select! { |x| x[index] == '1' }
    else 
      only_most_common.select! { |x| x[index] == char_counts_at_index.max_by {|_, v| v }.first }
    end
    index += 1
  end
  only_most_common[0].to_i(2)
end  

def co2_scrubber_rating(number_array)
  only_most_common = number_array.clone
  index = 0

  until only_most_common.length == 1
    grouped_on_index = group_strings_on_index(only_most_common)
    char_counts_at_index = char_counts(grouped_on_index[index])
    if char_counts_at_index['0'] == char_counts_at_index['1']
      only_most_common.select! { |x| x[index] == '0' }
    else 
      only_most_common.select! { |x| x[index] == char_counts_at_index.min_by {|_, v| v }.first }
    end
    index += 1
  end
  only_most_common[0].to_i(2)
end


oxygen_scrubber = oxygen_generator_rating(data)
co2_scrubber =  co2_scrubber_rating(data)
answer = oxygen_scrubber * co2_scrubber
puts "The answer to part two is #{answer}"