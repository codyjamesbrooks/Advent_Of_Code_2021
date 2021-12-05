require 'enumerator'

file = File.open('input.txt')
data = file.readlines.join.split("\n")

called_numbers   = data.first.split(',')
all_bingo_card_numbers =  data[2..].select {|x| !x.empty? }

class BingoCard
  attr_accessor :card
  attr_reader :selection
  def initialize( card )
    @card = card.map(&:split).map do |row|
      row.map! {|number| { number: number, selected: false }}
    end
    @selection = []
  end

  def stamp( number )
    @card.each do |row| 
      row.map do |option| 
        if option[:number] == number
          option[:selected] = true 
          @selection << number
        end 
      end 
    end 
  end 

  def bingo?
    (@card.any? { |row| row.all? { |option| option[:selected] == true } } ||
     @card.transpose.any? { |col| col.all? { |option| option[:selected] == true} })
  end 

  def score
    not_selected = @card.flatten.select { |option| option[:selected] == false }
    not_selected.reduce(0) { |score, option| score + option[:number].to_i } * @selection.last.to_i
  end 
end 


all_bingo_cards  = []
all_bingo_card_numbers.each_slice(5) do |card| 
  all_bingo_cards << BingoCard.new(card) 
end

class Game
  attr_reader :bingo_cards
  def initialize( bingo_cards, called_numbers )
    @called_numbers = called_numbers
    @bingo_cards    = bingo_cards
    @round          = 0
  end

  def play
    until winner?
      call(@called_numbers[@round])
      @round += 1
    end
    puts "BINGO - Winner Card score #{winner.score}"
  end 

  def call( number )
    @bingo_cards.each { |card| card.stamp(number) }
  end 

  def winner? 
    @bingo_cards.any? { |card| card.bingo? }
  end

  def winner
    @bingo_cards.select { |card| card.bingo? }.first
  end
end 

puts "Part One"
bingo_game = Game.new(all_bingo_cards, called_numbers)
bingo_game.play
puts ""

# Part Two 
# Love the Squid Game Nod

class SquidGame < Game
  def play
    until one_card_remains
      call(@called_numbers[@round])
      @round += 1
    end
    puts "Only one card remains"
    losers_final_salute
  end
  
  def one_card_remains
    @bingo_cards.one? { |card| card.bingo? == false }
  end 

  def loser
    @bingo_cards.select { |card| card.bingo? == false }.last
  end

  def losers_final_salute
    last_player = loser
    until last_player.bingo?
      call(@called_numbers[@round])
      @round += 1
    end 
    puts "BINGO - the last player finally exclaims"
    puts "But the hall is empty"
    puts "No one remains to celebrate"
    puts "The answer to part two is #{last_player.score}"
  end 
end 

puts "Part Two"
squid_game = SquidGame.new(all_bingo_cards, called_numbers)
squid_game.play