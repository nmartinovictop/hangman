require_relative 'game.rb'

g = Game.new
until g.game_over?
    g.guess_letter
end
g.game_over?

#issue with gameplay