require "tty-prompt"
require "tty-reader"
class Game
  Dir["lib/*.rb"].each {|file| require_relative file }
  def initialize
    puts "Kurac palac"
  end
  duro = Player::Base.new("Đuro", 1, 0,100, 5, 13, 0, 0, false, [], [], nil, [], nil, "Đ", "asdf")
  pero = Player::Base.new("Pero", 1, 0,100, 5, 13, 0, 0, false, [], [], nil, [], nil, "Đ", "asdf")
  p Player::Base.all


  prompt = TTY::Prompt.new
  prompt.yes?("Do you like Ruby?")


  reader = TTY::Reader.new
  loop do
    puts "\e[H\e[2J"
    States::Base.game
    key=reader.read_keypress
    keypress=reader.on(:keyescape) do
      puts "Escape"
      States::Base.main_menu
      keypress2=reader.on(:keyescape) do
        States::Base.game
      end
    end
  end
end
