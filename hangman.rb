# hangman, select a secret word
# draw the stand
# give player opportunity to guess
# if guess exists in word, display letter
# if not, add body part (counter to keep track of how many? or hash true/false each body part?)
# if already guessed, should tell the user that
#allow for phrases??

# PROBLEM WITH WORD GUESS
require "colorize"

class Game

  def initialize()
    @rows = []
    @board = Board.new(@rows)
  end

  def draw_board
    @board.draw
  end

  class Board
    attr_accessor :rows

    def initialize(rows)
      @rows = rows
    end

    def draw()
      @rows.each do |row|
        puts row
      end
    end

  end
end


class Hangman < Game
  attr_reader :word, :board

  def initialize
    dictionary = %w[cat hat mat flat red blue green sky moo moon hope hopeful hopefulness shout grout
    doubt axiom bagpipes boxcar gazebo fixable buggalo bookworm haphazard hazard galaxy fish trout salmon injury
    advocate joyful juicy drinkable kazoo nightclub microwave oxygen carbon hyphen hypnosis khaki kayak pajama trousers
    pants tophat meow giraffe elephant vortex wizard staff life zombie youth elder gnarly rhythm line queue sphynx psyche
    rickshaw mouth eyeball football silverwear spoon doormat rainbow skyscraper knight desk build love glove shove hair jacket
    kitten puppy snail raptor eagle sweater shoelace zipper sandal]
    @word = dictionary.sample.upcase
    @body_part_count = 0
    @guessed_letters = []
    @letters = @word.split(//)
    @gameover = false
    @colors = which_colors(String.colors)
    @body_parts = ["(_)", "/", "|", "\\", "|", "\\", "/"]
    @rows = [" |     __________  ",
             " |     |/       |  ",
             " |     |           ",
             " |     |           ",
             " |     |           ",
             " |     |           ",
             " |     |           ",
             " | ____|___        "]
    @board = Board.new(@rows)
  end

  def run
    random_color_the_body(@colors)
    while @gameover == false
      @board.draw
      puts
      word_display
      puts
      display_guesses
      2.times { puts }
      accept_guess
      puts "You've made #{@body_part_count} wrong guesses."
      win
      lose
    end
    thats_all
  end

  def which_colors(colors)
    colors.delete(:black)
    colors.delete(:white)
    return colors
  end


  def display_guesses
    print "You've already guessed: "
    print @guessed_letters.join(", ")
  end

  def word_display
    print "\t"
    @letters.each do |char|
      if @guessed_letters.include? char
        print char + " "
      else
        print "_ "
      end
    end
    puts
  end

  def thats_all
    abort("\nSee ya later!")
  end

  def word_guess(guess)
    if guess == word
      guess.split(//).each { |l| @guessed_letters << l }
    else
      wrong_guess
    end
  end

  def wrong_guess
    @body_part_count += 1
    add_body_part
  end

  def guess_good_format(guess)
    if guess.length == @word.length
      word_guess(guess)
    elsif guess.length == 1
      letter_guess(guess)
    else
      puts "What? How did this happen?"
    end
  end

  def letter_guess(guess)
    @guessed_letters << guess
    unless @letters.include? guess
      wrong_guess
    end
  end


  def accept_guess
    loop do
      print "> "
      guess = gets.chomp.upcase
      if guess == "EXIT" || guess == "QUIT" || guess == "END"
        thats_all
      elsif guess.length > 1 && guess.length != @word.length
        puts "Guess just one letter, or the whole word. (pay attention to length)"
      elsif @guessed_letters.include? guess
        puts "You've already guessed that one"
      else
        guess_good_format(guess)
      end
      break
    end
  end

  def lose
    if @body_part_count > 6
      @board.draw
      puts "You LOSE! The word was #{@word}."
      @gameover = true
    end
  end

  def win
      if (@letters - @guessed_letters).empty?
      @board.draw
      puts "You WIN! The word was #{@word}"
      @gameover = true
    end
  end

  def random_color_the_body(colors)
    (0..@body_parts.length-1).each do |index|
      @body_parts[index] = @body_parts[index].colorize(colors.sample)
    end
  end

  def add_body_part
    part_index = @body_part_count - 1
    coordinate_hash = {0 => [2,(15..17)], 1 => [3,17], 2 => [3,16], 3 => [3,15], 4 => [4,16], 5 => [5,17], 6 => [5,15]}
    x = coordinate_hash[part_index][0]
    y = coordinate_hash[part_index][1]
    @board.rows[x][y] = (@body_parts[part_index])
  end


end

thisgame = Hangman.new
thisgame.run
