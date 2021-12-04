require 'enumerator'

file = File.open('input.txt')
data = file.readlines.join.split("\n")

called_numbers   = data.first.split(',')
all_bingo_card_numbers =  data[2..].select {|x| !x.empty? }

class BingoCard
  attr_accessor :card, :win_round
  def initialize( card )
    @card = card.map(&:split).map do |row|
      row.map! {|number| { number: number, selected: false }}
    end
    @win_round = nil
    @win_score = nil
  end

  def stamp( number )
    @card.each { |row| row.map { |option| option[:selected] = true if option[:number] == number } }
  end 

  def set_win_score( win_number )
    unselected = @card.flatten.select {|o| o[:selected] == false }
    @win_score = unselected.reduce(0) {|count, x| count + x[:number].to_i } * win_number.to_i
  end 

  def bingo?
    (@card.any? { |row| row.all? { |option| option[:selected] == true } } ||
     @card.transpose.any? { |col| col.all? { |option| option[:selected] == true} })
  end 

  def to_s
    "Bingo card - Wins on Round #{@win_round} - With a score of #{@win_score}"
  end 

  def display
    @card.each { |row| puts "#{row.map { |option| option[:number] }.join(" ") }" }
  end 
  
end 

class Game
  attr_reader :bingo_cards
  def initialize( bingo_cards, called_numbers )
    @called_numbers = called_numbers
    @bingo_cards    = bingo_cards
    @round          = 0
  end

  def assign_win_round
    @bingo_cards.each do |card|
      index = 0
      until card.bingo? 
        card.stamp(@called_numbers[index])
        index += 1
      end
      card.win_round = index - 1
      card.set_win_score(@called_numbers[index-1])
    end 
  end 
  
  def play
    until winner?
      call(@called_numbers[@round])
      @round += 1
    end 
    score_winner
  end 

  def call( number )
    @bingo_cards.each { |card| card.stamp(number) }
  end 

  def winner? 
    @bingo_cards.any? { |card| card.bingo? }
  end

  def score_winner
    winner = @bingo_cards.select { |card| card.bingo? }.first
    not_selected = winner.card.flatten.select { |option| option[:selected] == false }
    not_selected.reduce(0) {|total, option| total + option[:number].to_i } * @called_numbers[@round - 1].to_i
  end 
end 


all_bingo_cards  = []
all_bingo_card_numbers.each_slice(5) do |card| 
  all_bingo_cards << BingoCard.new(card) 
end

bingo_game = Game.new(all_bingo_cards, called_numbers)

# answer = bingo_game.play
# puts "the answer to part one is #{answer}"


# Part Two 
# Love the Squid Game Nod

squid_game = Game.new(all_bingo_cards, called_numbers)
squid_game.assign_win_round
p squid_game.bingo_cards.sort_by { |card| -card.win_round }.first

# class SquidGame < Game
#   def play 
#     79.times do |_| 
#       call(@called_numbers[@round])
#       @round += 1
#     end

#     # until loser.bingo?
#     #   call(@called_numbers[@round])
#     #   @round += 1
#     # end 
#     # score_winner
#   end 

#   def losers
#     puts "next number #{@called_numbers[@round]}"
#     @bingo_cards.select { |card| card.bingo? == false } 
#   end 


#   def loser? 
#     @bingo_cards.one? { |card| card.bingo? == false }
#   end 

#   def get_loser 
#     @bingo_cards.select { |card| card.bingo? == false }.last
#   end 
# end 

# squid_game = SquidGame.new(all_bingo_cards, called_numbers)
# squid_game.play
# loser1, loser2 = squid_game.losers
# [loser1, loser2].each { |loser| loser.stamp("61") }

# unselected1 = loser1.card.flatten.select { |option| option[:selected] == false }
# unselected2 = loser2.card.flatten.select { |option| option[:selected] == false }

# potential1 = unselected1.reduce(0) { |total, option| total + option[:number].to_i } * 61
# potential2 = unselected2.reduce(0) { |total, option| total + option[:number].to_i } * 61

# puts "the answer to part 2 is #{potential1} or #{potential2}"