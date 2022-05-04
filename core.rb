require "tty-prompt"
require "tty-reader"
require "dead_end"

class Game
  Dir["lib/*.rb"].each do |file| require_relative file end

  def initialize
    @@objects=Initialize::Base.get_objects
    Initialize::Base.setup_map(@@objects)
    puts Map::Base.entire_map
  end

  def self.open_inventory(player)
    prompt=TTY::Prompt.new
    temp_dict={}
    #PUT ALL PLAYERS ITEMS IN DICT
    player.inventory.slots.each_with_index do |item, i|
      temp_dict[(i+1).to_s+". "+item.name]=item
    end
    #IF DICT EMPTY THEN INVENTORY EMPTY
    if temp_dict.size==0
      puts "INVENTORY EMPTY"

      prompt.yes?("Proceed?")

      return 1
    end
    #SELECT ITEM FROM INVENTORY
    selected=prompt.select("__Inventory__", temp_dict)
    puts selected
    if selected.item_type=="Consumable"
      choice=prompt.select(selected, %w(Use Destroy Back))
      if choice=="Use"
        player.use_item(selected)
        player.inventory.item_remove(selected)
        return 1
      elsif choice=="Destroy"
        player.drop_item(selected)
        return 1
      else
        return 1
      end
    elsif selected.item_type=="Weapon"
      choice=prompt.select(selected, %w(Use Destroy Back))
      if choice=="Use"
        player.equip_weapon(selected)
        player.inventory.item_remove(selected)
        return 1
      elsif choice=="Destroy"
        player.drop_item(selected)
        return 1
      else
        return 1
      end
    end
    return 1
  end
  def self.view_weapon(player)
    prompt=TTY::Prompt.new

    #IF WEAPON EQUIPPED
    if player.equipped_weapon!=nil
      puts player.equipped_weapon.name
      w=prompt.yes?("Unequip weapon?")
      if w
        player.unequip_weapon
      end
    #IF WEAPON UNEQUIPPED
    else
      puts "No weapon equipped!"
      prompt.yes?("Proceed?")
    end
    return 1
  end
  def self.create_player(name, marker)
    Player::Stats.new
    return Player::Base.new(name, 1, 0,100, 5, 2, 0, 0, false, [], Inventory::Base.new(10,[],500), nil, [], nil, marker, "asdf")
  end
  def self.play(player)
    reset_reader=0
    reader = TTY::Reader.new
    loop do
      puts "\e[H\e[2J"
      States::Base.game(player)
      puts("↑,↓,←,→ - Move around, I - Inventory, Q - Weapon, Esc - Main Menu")
      puts("Player position: "+player.pos_x.to_s+","+player.pos_y.to_s)
      puts("Health: "+player.health.to_s+", Level: "+player.level.to_s+", XP: "+player.xp.to_s+", DMG: "+player.damage.to_s+", Gold: "+player.inventory.gold.to_s)

      #HELPER
      reader.read_keypress

      #MAIN MENU
      reader.on(:keyescape) do
        puts "Escape"
        States::Base.main_menu
        reader.on(:keyescape) do
          States::Base.game(player)
        end
      end

      #PLAYER COORDINATES
      new_x=player.pos_x.clone
      new_y=player.pos_y.clone

      #READ PLAYER MOVEMENT
      reader.on(:keyup) do
        reset_reader=0
        player.move_to(new_x-1, new_y)
      end
      reader.on(:keydown) do
        reset_reader=0
        player.move_to(new_x+1, new_y)
      end
      reader.on(:keyleft) do
        reset_reader=0
        player.move_to(new_x, new_y-1)
      end
      reader.on(:keyright) do
        reset_reader=0
        player.move_to(new_x, new_y+1)
      end

      #READ SPECIAL KEYPRESS
      reader.on(:keypress) do |event|
        #IF PLAYER PRESSED q VIEW WEAPON
        if event.value == "q" and reset_reader==0
          reset_reader=view_weapon(player)
        end
        #IF PLAYER PRESSED i OPEN INVENTORY
        if event.value == "i" and reset_reader==0
          reset_reader=open_inventory(player)
        end
        if event.value == "s" and reset_reader==0
          reset_reader=Player::Stats.show
        end

      end

      #READ PLAYER INTERACTIONS
      reader.on(:keyf1) do
        if reset_reader==0
          player.interact(States::Base.objects_near[0])
        end
        reset_reader=1
      end
      reader.on(:keyf2) do
        if reset_reader==0
          player.interact(States::Base.objects_near[1])
        end
        reset_reader=1
      end
      reader.on(:keyf3) do
        if reset_reader==0
          player.interact(States::Base.objects_near[2])
        end
        reset_reader=1
      end

    end
  end

  Game.new

  prompt = TTY::Prompt.new
  prompt.keypress("Press space or enter to start game", keys: [:space, :return])

  name=prompt.ask("Enter your name: ", default:"Ždero")
  marker = prompt.select("Please choose your map marker", %w(¿ ® ¥ ¤))

  #INITIALIZE PLAYER
  player = create_player(name, marker)
  play(player)
end
