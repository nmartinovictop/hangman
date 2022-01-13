require 'yaml'


class Game
    attr_reader :word, :render_word

    
    
    def initialize
        @word = read_in_file
        @render_word = Array.new(@word.length,"_")
        @guesses_remaining = 100
        @guessed_letters = []
        @letters = []
        ('a'..'z').each { |x| @letters.push(x)}
    end

    def read_in_file
        file = File.open('words.txt','r')
        contents = file.readlines
        available_words = contents.filter { |x| x.length>= 6 && x.length <= 13}
        available_words.sample.chomp 
    end

    def guess_letter

        render
        puts "Please guess a letter between A-Z."
        letter = gets.chomp.downcase
        if !letter_available(letter)
            puts "Please enter a letter that you have not guessed!!"
            puts
            return
        end
        #remove letter from letters
        @letters.delete(letter)
        @guessed_letters.push(letter)
        #check letter is in word
        if letter_is_in_word?(letter)
            puts "That letter is in the word.  You have #{@guesses_remaining} guesses remaining"

        else
            puts "That letter is not in the word.  You have #{@guesses_remaining-=1} guesses remaining"

        end
        system('clear')
        #render

    end

    def to_yaml
        YAML.dump({
            :word => @word,
            :render_word => @render_word,
            :guesses_remaining => @guesses_remaining,
            :guessed_letters => @guessed_letters,
            :letters => @letters}
        )
    end

    def self.import_from_yaml(file)
        data = YAML.load(file)
        puts data
        #self.new(data[:word], data[:render_word], data[:guesses_remaining], data[:guessed_letters], data[:letters])
    end

    def save_game(filename,serialized_object)
        fname = filename+'.yaml'
        somefile = File.open(fname, "w")
        somefile.puts serialized_object
        somefile.close

    end


    def letter_available(letter)
        @letters.include?(letter)
    end

    def letter_is_in_word?(letter)
        if @word.include?(letter)
            array_of_letters(letter).each do |i|
                @render_word[i] = letter
            end
            true
        else
            false
        end
    end

    def show_guessed_letters
        @guessed_letters

    end

    def array_of_letters(letter)
        array = []
        @word.split("").each_with_index do |e,i|
            if e == letter
                array.push(i)
            end
        end
        array

    end

    def render
        puts @render_word.join(" ")
        puts "You have guessed #{@guessed_letters}"
        puts "You have #{@guesses_remaining} remaining"

    end

    def game_over?
        guess_letter
        if @render_word.join("") == @word
            puts "You have won the game.  The word was #{@word}"
            true
        elsif @guesses_remaining == 0
            puts "You have run out of guesses.  The word was #{@word}"
            true
        else
            false
        end

    end

end