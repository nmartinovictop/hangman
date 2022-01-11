


class Game
    attr_reader :word

    
    
    def initialize
        @word = 'doghouse'
        @render_word = Array.new(5,"_")
        @guesses_remaining = 5
        @letters = []
        ('a'..'z').each { |x| @letters.push(x)}
    end

    def guess_letter
        puts "Please guess a letter between A-Z"
        letter = gets.chomp.downcase
        if !letter_available(letter)
            puts "Please enter a letter that you have not guessed"
            guess_letter
        end
        #remove letter from letters
        @letters.delete(letter)
        #check letter is in word
        if letter_is_in_word?(letter)
            puts "That letter is in the word"
        else
            puts "That letter is not in the word"
        end
        render
        #render

    end

    def letter_available(letter)
        @letters.include?(letter)
    end

    def letter_is_in_word?(letter)
        if @word.include?(letter)
            @word.count.each do |i|
                @render_word[@word.index(letter)] = letter
            end
            true
        else
            false
        end
    end

    def render
        puts @render_word.join(" ")

    end

    def game_over?
        guess_letter
        if @render_word.join("") == @word
            puts "You have won the game"
            true
        elsif @guesses_remaining == 0
            puts "You have run out of guesses.  The word was #{@word}"
            true
        else
            false
        end

    end

end