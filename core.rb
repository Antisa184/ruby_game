require "tty-prompt"
require "tty-reader"
require "dead_end"

class Game
  Dir["lib/*.rb"].each do |file| require_relative file end

  def initialize
    puts "kurac palac"
  end
  @@objects=[]

  @@objects.append(Item::Consumable.new("Small Health potion", "Restores 30 HP", 25, true, true, 1, "Consumable", 1, false, "Restore 30 HP",1))
  @@objects.append(Item::Consumable.new("Large Health potion", "Restores 60 HP", 40, true, true, 1, "Consumable", 2, false, "Restore 60 HP",2))
  @@objects.append(Item::Consumable.new("Small Health potion", "Restores 30 HP", 25, true, true, 1, "Consumable", 1, false, "Restore 30 HP",1))
  @@objects.append(Item::Consumable.new("Large Health potion", "Restores 60 HP", 40, true, true, 1, "Consumable", 2, false, "Restore 60 HP",2))

  @@objects.append(Item::Weapon.new("Common Dagger", "Small knife", 50, true, false, 1, "Weapon", 1, false, 20, 1, 1))
  @@objects.append(Item::Weapon.new("Common Dagger", "Small knife", 50, true, false, 1, "Weapon", 1, false, 20, 1, 1))
  @@objects.append(Item::Weapon.new("Better Dagger", "Small sharp knife", 120, true, false, 1, "Weapon", 3, false, 20, 3, 2))
  @@objects.append(Item::Weapon.new("Better Dagger", "Small sharp knife", 120, true, false, 1, "Weapon", 3, false, 20, 3, 2))

  @@objects.append(NPC::Enemy.new("Đuro", 25, 15, 5, 2, 35, [], false, "E", "asdf", 3))
  @@objects.append(NPC::Enemy.new("Đuro", 29, 10, 5, 2, 35, [], false, "E", "asdf", 3))
  @@objects.append(NPC::Enemy.new("Đuro", 27, 20, 5, 2, 35, [], false, "E", "asdf", 3))

  map = Map::Base.new("mapa", 71, 30, [], nil)
  @@objects.each do |item|
    if item.is_a?(NPC::Enemy)
      x=item.pos_x.to_i
      y=item.pos_y.to_i
    else
      x=rand(0...Map::Base.height)
      y=rand(0...Map::Base.width)
    end
    Map::Base.add_object(item, x, y)
    puts item.attributes, "\n"
  end

  Map::Base.add_object(Item::Weapon.new("Common Dagger", "Small knife", 50, true, false, 1, "Weapon", 1, false, 20, 1, 2), 5,7)
  Map::Base.add_object(NPC::Enemy.new("Đuro", 25, 15, 5, 2, 35, [], false, "E", "asdf", 3), 5, 5)
  Map::Base.add_object(Item::Consumable.new("Small Health potion", "Restores 30 HP", 25, true, true, 2, "Consumable", 1, false, "Restore 30 HP",1), 6, 6)

  puts Map::Base.entire_map

  prompt = TTY::Prompt.new
  prompt.keypress("Press space or enter to start game", keys: [:space, :return])

  name=prompt.ask("Enter your name: ", default:"Ždero")
  choices = %w(¿ ® ¥ ¤)
  marker = prompt.multi_select("Please choose your map marker", choices)
  player = Player::Base.new(name, 1, 0,100, 5, 2, 0, 0, false, [], Inventory::Base.new(10,[],500), nil, [], nil, marker.first, "asdf")

  krv_ti_jebem = 0

  reader = TTY::Reader.new
  loop do
    puts "\e[H\e[2J"

    States::Base.game(player)
    puts("↑,↓,←,→ - Move around, I - Inventory, Esc - Main Menu")
    puts("Player position: "+player.pos_x.to_s+","+player.pos_y.to_s)
    puts("Health: "+player.health.to_s+", Level: "+player.level.to_s+", XP: "+player.xp.to_s)
    #puts States::Base.objects_near
    key=reader.read_keypress
    keypress=reader.on(:keyescape) do
      puts "Escape"
      States::Base.main_menu
      keypress2=reader.on(:keyescape) do
        States::Base.game(player)
      end
    end
    new_x=player.pos_x.clone
    new_y=player.pos_y.clone
    keypress=reader.on(:keyup) do
      krv_ti_jebem=0
      player.move_to(new_x-1, new_y)
    end
    keypress=reader.on(:keydown) do
      krv_ti_jebem=0
      player.move_to(new_x+1, new_y)
    end
    keypress=reader.on(:keyleft) do
      krv_ti_jebem=0
      player.move_to(new_x, new_y-1)
    end
    keypress=reader.on(:keyright) do
      krv_ti_jebem=0
      player.move_to(new_x, new_y+1)
    end
    keypress=reader.on(:keyf1) do
      if krv_ti_jebem==0
        player.interact(States::Base.objects_near[0])
      end
      krv_ti_jebem=1
    end
    keypress=reader.on(:keyf2) do
      if krv_ti_jebem==0
        player.interact(States::Base.objects_near[1])
      end
      krv_ti_jebem=1
    end
    keypress=reader.on(:keyf3) do
      if krv_ti_jebem==0
        player.interact(States::Base.objects_near[2])
      end
      krv_ti_jebem=1
    end

  end
end
