require "tty-prompt"
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
  reader.on(:keyup)
end
