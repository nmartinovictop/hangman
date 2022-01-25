require 'yaml'


class Game
    attr_reader :word, :render_word

    
    
    def initialize(file=nil)
        if file == nil
            @word = read_in_file.downcase
            @render_word = Array.new(@word.length,"_")
            @guesses_remaining = @word.length
            @guessed_letters = []
            @letters = []
            ('a'..'z').each { |x| @letters.push(x)}
            @game_over = false
        else
            data = Game.import_from_yaml(file)
            @word = data[:word]
            @render_word = data[:render_word]
            @guesses_remaining = data[:guesses_remaining]
            @guessed_letters = data[:guessed_letters]
            @letters = data[:letters]
            @game_over = false
        end
    end

    def self.intro
        puts "Would you like to load a file? (y/n)"
        response = gets.chomp.downcase
        if response == 'y'
            puts "what is the name of the file to load?  Here are the available files"
            self.get_files
            filename = gets.chomp.downcase
            g = Game.new(file=filename)
        else
            g = Game.new
        end
        g
    end

    def read_in_file
        file = File.open('words.txt','r')
        contents = file.readlines
        available_words = contents.filter { |x| x.length>= 6 && x.length <= 13}
        available_words.sample.chomp 
    end


    def self.get_files
        files = Dir.entries(Dir.pwd)
        game_files = files.select { |x| x.include?('.yaml')}
        puts game_files
    end

    def guess_letter

        render
        puts "Please guess a letter between A-Z.  You can type 'save' to save the game"
        letter = gets.chomp.downcase
        if !letter_available(letter) && !(letter == 'save')
            system('clear')
            puts "Please enter a letter that you have not guessed!!"
            puts
            return
        end
        if letter == 'save'
            save
            @game_over = true
            return
        end
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

    def save
        puts "We will save your file.  Please enter the name of the file"
        fname = gets.chomp.downcase
        save_game(fname,self.to_yaml)
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
        loaded_file = File.open(file,'r')

        data = YAML.load(loaded_file.read)
        #puts data
 

        data
        
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
            @game_over
        end

    end

end