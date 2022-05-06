require 'tty-prompt'
require 'tty-reader'

module Item
  class Base
    attr_accessor :id, :name, :description, :gold, :usable, :stackable, :count, :item_type, :rarity, :equipped
    @@count=0
    @@id_default=1
    @@instances=[]

    def attributes
      @atts
    end

    def initialize(name, description, gold, usable, stackable, count, item_type, rarity, equipped, id = @@id_default)
      @id= id
      @name = name
      @description = description
      @gold = gold
      @usable = usable
      @stackable = stackable
      @count = count
      @item_type = item_type
      @rarity = rarity
      @equipped = equipped
      @atts = ["Name: "+@name, "Desc: "+@description.to_s, "Gold: "+@gold.to_s, "Usable: "+@usable.to_s, "Stackable: "+@stackable.to_s, "Count: "+@count.to_s, "Item type: "+@item_type.to_s, "Rarity: "+@rarity.to_s, "Equipped: "+@equipped.to_s]
      if @id == @@id_default then @@id_default+=1 end
      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def self.count
      @@count
    end

  end

  class Weapon < Base

    attr_accessor :id_default, :damage, :req_lvl

    def attributes
      @atts
    end

    def initialize(name, description, gold, usable, stackable,
                   count, item_type, rarity, equipped,
                   damage, req_lvl, id = @@id_default)

      super(name, description, gold, usable, stackable,
            count, item_type, rarity, equipped, id)
      @damage = damage
      @req_lvl = req_lvl
      @atts = ["Id: "+@id.to_s, "Name: "+@name, "Desc: "+@description.to_s, "Gold: "+@gold.to_s, "Usable: "+@usable.to_s, "Stackable: "+@stackable.to_s, "Count: "+@count.to_s, "Item type: "+@item_type.to_s, "Rarity: "+@rarity.to_s, "Equipped: "+@equipped.to_s, "Damage: "+@damage.to_s,"Required lvl: "+ @req_lvl.to_s]
    end

  end

  class Consumable < Base

    attr_accessor :id_default, :on_use

    def attributes
      @atts
    end

    def initialize(name, description, gold, usable, stackable,
                   count, item_type, rarity, equipped,
                   on_use, id = @@id_default)

      super(name, description, gold, usable, stackable,
            count, item_type, rarity, equipped, id)
      @on_use = on_use
      @atts = ["Id: "+@id.to_s, "Name: "+@name, "Desc: "+@description.to_s, "Gold: "+@gold.to_s, "Usable: "+@usable.to_s, "Stackable: "+@stackable.to_s, "Count: "+@count.to_s, "Item type: "+@item_type.to_s, "Rarity: "+@rarity.to_s, "Equipped: "+@equipped.to_s, "On use: "+@on_use.to_s]
    end

  end
end
module Inventory
  class Base
    attr_reader :id, :max_slots, :slots, :gold
    @@count=0
    @@id_default=1
    @@instances=[]

    def initialize(max_slots, slots, gold, id = @@id_default)
      @id=id
      @max_slots=max_slots
      @slots=slots
      @gold=gold
      if @id == @@id_default then @@id_default+=1 end
      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def self.count
      @@count
    end

    def pretty_slots
      slots_string=""
      @slots.each_with_index do |item, i| item
      slots_string+=(i+1).to_s+". "+item.attributes.to_s+"\n"
        ##puts (i+1).to_s+". "+item.attributes.to_s
      end
      slots_string
    end
    def reset_inv
      @slots=[]
      @gold=0
    end

    def gain_gold(gold)
      @gold+=gold
    end
    def lose_gold(gold)
      @gold-=gold
    end

    def item_remove(item)
      @slots.each_with_index do |items, i| items
      if item.id == items.id
        @slots.delete_at(i)
        return
      end
      end
    end
    def item_add(item)
      @slots.append(item)
    end
    def upgrade_slots(max_slots)
      @max_slots = max_slots
    end
  end
end
module Initialize
  class Base
    def self.to_bool(state)
      if state=="true"
        return true
      else
        return false
      end
    end
    def self.load_quests(objects, file, sep)
      file.each do |line|
        lineSplit = line.split(sep)
        objects.append(Quest::Base.new(lineSplit[0], lineSplit[1], lineSplit[2].split(" "), lineSplit[3].to_i, lineSplit[4].to_i))
      end
      return objects
    end
    def self.load_items(objects, file, sep)
      file.each do |line|
        lineSplit = line.split(sep)
        if lineSplit[6]=="Consumable"
          objects.append(Item::Consumable.new(lineSplit[0], lineSplit[1],lineSplit[2].to_i, Initialize::Base.to_bool(lineSplit[3]), Initialize::Base.to_bool(lineSplit[4]), lineSplit[5].to_i, lineSplit[6], lineSplit[7].to_i, Initialize::Base.to_bool(lineSplit[8]), lineSplit[9], lineSplit[10].to_i))
        elsif lineSplit[6]=="Weapon"
          objects.append(Item::Weapon.new(lineSplit[0], lineSplit[1],lineSplit[2].to_i, Initialize::Base.to_bool(lineSplit[3]), Initialize::Base.to_bool(lineSplit[4]), lineSplit[5].to_i, lineSplit[6], lineSplit[7].to_i, Initialize::Base.to_bool(lineSplit[8]), lineSplit[9].to_i, lineSplit[10].to_i, lineSplit[11].to_i))
        end
      end
      return objects
    end
    def self.load_npcs(objects, file)
      file.each do |line|
        lineSplit = line.split(";")
        if lineSplit[0]=="Enemy" or lineSplit[0]=="EnemyBoss"
          items=lineSplit[7].split("|")
          enemy_inventory=Initialize::Base.load_items([], items, ",")
          if lineSplit[0]=="Enemy"
            objects.append(NPC::Enemy.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, lineSplit[4].to_i, lineSplit[5].to_i, lineSplit[6].to_i, Inventory::Base.new(lineSplit[7].to_i,enemy_inventory, lineSplit[9].to_i, lineSplit[10].to_i), Initialize::Base.to_bool(lineSplit[11]), lineSplit[12], lineSplit[13], lineSplit[14].to_i))
          else
            objects.append(NPC::EnemyBoss.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, lineSplit[4].to_i, lineSplit[5].to_i, lineSplit[6].to_i, Inventory::Base.new(lineSplit[7].to_i,enemy_inventory, lineSplit[9].to_i, lineSplit[10].to_i), Initialize::Base.to_bool(lineSplit[11]), lineSplit[12], lineSplit[13], lineSplit[14].to_i))
          end
        elsif lineSplit[0]=="Shop"
          items=lineSplit[5].split("|")
          enemy_inventory=Initialize::Base.load_items([], items, ",")
          objects.append(NPC::Shop.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, Inventory::Base.new(lineSplit[4].to_i, enemy_inventory, lineSplit[5].to_i, lineSplit[6].to_i), lineSplit[7].to_i))
        elsif lineSplit[0]=="QuestGiver"
          items=lineSplit[4].split("|")
          quests=Initialize::Base.load_quests([], items, ",")
          objects.append(NPC::QuestGiver.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, quests, lineSplit[5].to_i))
        end
      end
      return objects
    end
    def self.load_abilities(objects, file)
      file.each do |line|
        lineSplit = line.split(",")
        ability=Abilities::Base.new(lineSplit[0], lineSplit[1].to_i,lineSplit[2][0...-1])
        objects.append(ability)
      end
      objects
    end
    def self.determine_level(xp)
      File.open(File.join(Dir.pwd,"/data/levels")).each do |line|
        if xp<line.split(",")[0].to_i then return line.split(",")[1].to_i end
      end
    end
    def self.get_objects
      objects=[]

      #LOAD ITEMS
      objects=Initialize::Base.load_items(objects, File.open(File.join(Dir.pwd,"/data/Items")),";")
      #LOAD NPCS
      objects=Initialize::Base.load_npcs(objects, File.open(File.join(Dir.pwd, "/data/NPCs")))
      #RETURN OBJECTS
      objects
    end
    def self.setup_map(objects)

      #CREATE AND DRAW MAP
      map_file=File.open(File.join(Dir.pwd,"/data/Map")).readlines
      Map::Base.new("mapa", map_file[0].size, map_file.size, [], nil)
      Map::Base.load_map(map_file)

      #PUTTING OBJECTS ON THE MAP
      objects.each do |item|
        if item.is_a?(NPC::Enemy) or item.is_a?(NPC::EnemyBoss) or item.is_a?(NPC::Shop) or item.is_a?(NPC::QuestGiver)
          x=item.pos_x.to_i
          y=item.pos_y.to_i
        else
          x=rand(0...Map::Base.height)
          y=rand(0...Map::Base.width)
        end
        Map::Base.add_object(item, x, y)
      end

      #TEST OBJECTS
      Map::Base.add_object(Item::Weapon.new("Common Dagger", "Small knife", 50, true, false, 1, "Weapon", 1, false, 20, 1, 2), 5,7)
      Map::Base.add_object(NPC::Enemy.new("Đuro", 25, 15, 5, 2, 35, Inventory::Base.new(10, [], 20, 1234), false, "E", "asdf", 3), 5, 5)
      Map::Base.add_object(Item::Consumable.new("Small Health potion", "Restores 30 HP", 25, true, true, 2, "Consumable", 1, false, "Restore 30 HP",1), 6, 6)

    end
  end
end
module Player
  class Stats

    attr_accessor :kills, :gold_collected, :gold_spent, :items_collected, :steps, :damage_dealt, :damage_taken, :healed, :xp_gained, :killed, :items

    def initialize
      @kills=0
      @killed=[]
      @gold_collected=0
      @gold_spent=0
      @items_collected=0
      @items=[]
      @steps=0
      @damage_dealt=0
      @damage_taken=0
      @healed=0
      @xp_gained=0
      @@atts=["Kills: "+@kills.to_s, "Gold collected: "+@gold_collected.to_s, "Gold spent: "+@gold_spent.to_s, "Items collected: "+@items_collected.to_s, "Steps taken: "+@steps.to_s,
              "Damage dealt: "+@damage_dealt.to_s, "Damage taken: "+@damage_taken.to_s, "Healed: "+@healed.to_s, "XP gained: "+@xp_gained.to_s]
    end
    def killed
      @killed
    end
    def show
      @@atts=["Kills: "+@kills.to_s, "Gold collected: "+@gold_collected.to_s, "Gold spent: "+@gold_spent.to_s, "Items collected: "+@items_collected.to_s, "Steps taken: "+@steps.to_s,
              "Damage dealt: "+@damage_dealt.to_s, "Damage taken: "+@damage_taken.to_s, "Healed: "+@healed.to_s, "XP gained: "+@xp_gained.to_s]

      @@atts.each do |att|
        puts att
      end
      TTY::Prompt.new.yes?("Back")
      return 1
    end
  end

  class Base
    @@count=0
    @@id_default=1
    @@instances=[]

    attr_reader :name, :pos_x, :pos_y, :map_marker, :health, :equipped_weapon, :xp, :level, :damage, :armor, :inventory, :stats, :quests, :abilities
    attr_writer :damage, :health, :abilities

    def initialize(name, level, xp, health, damage, armor, pos_x, pos_y, dead, quests, inventory, equipped_weapon, abilities, interacting_with, map_marker, image, stats, id = @@id_default)
      @id = id
      if @id == @@id_default then @@id_default+=1 end
      @name = name
      @level = level
      @xp = xp
      @health = health
      @damage = damage
      @armor = armor
      @pos_x = pos_x
      @pos_y = pos_y
      @dead = dead
      @quests = quests
      @inventory = inventory
      @equipped_weapon = equipped_weapon
      @abilities = abilities
      @interacting_with = interacting_with
      @map_marker = map_marker
      @image = image
      @stats = stats

      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def gain_xp(xp)
      @stats.xp_gained+=xp
      @xp+=xp
      @level=Initialize::Base.determine_level(@xp)
    end

    def gain_gold(gold)
      @inventory.gain_gold(gold)
      @stats.gold_collected+=gold
    end

    def lose_gold(gold)
      @inventory.lose_gold(gold)
      @stats.gold_spent+=gold
    end

    def self.count
      @@count
    end

    def equip_weapon (weapon)
      if weapon.req_lvl>self.level
        puts "You need to be level "+weapon.req_lvl.to_s+" to use this weapon."
        #TTY::Prompt.new.yes?("Proceed?")
        return
      end
      if @equipped_weapon!=nil
        self.take_item(@equipped_weapon)
        @equipped_weapon=nil
      end
      @equipped_weapon = weapon
      @damage = weapon.damage
    end

    def unequip_weapon
      self.take_item(@equipped_weapon)
      @equipped_weapon = nil
      @damage = 5
    end

    def take_item (item)
      @inventory.item_add(item)
      @stats.items_collected+=1
      @stats.items.append(item)
    end

    def use_item (item)
      @stats.items_collected+=1
      @stats.items.append(item)
      #SMALL POTION
      if item.id==1
        @stats.healed+=30
        @health+=30
        #LARGE POTION
      elsif item.id==2
        @stats.healed+=60
        @health+=60
        #SMALL ARMOR
      elsif item.id==3
        @armor+=2
        #LARGE ARMOR
      elsif item.id==4
        @armor+=5
      end

    end

    def drop_item (item)
      @inventory.item_remove(item)
    end

    def sell_item(object)
      prompt=TTY::Prompt.new
      temp_dict={}
      self.inventory.slots.each_with_index do |item, i|
        temp_dict[(i+1).to_s+". "+item.name+" Gold: "+item.gold.to_s]=item
      end
      if temp_dict.size==0
        puts "INVENTORY EMPTY"
        #prompt.yes?("Proceed?")
        return
      end
      selected=prompt.select("__Inventory__", temp_dict)
      choice_=prompt.select(selected, %w(Sell Back))

      if choice_=="Sell"
        if object.inventory.gold-selected.gold>=0
          self.gain_gold(selected.gold)
          self.drop_item(selected)
          object.inventory.lose_gold(selected.gold)
          puts("Item sold, you gained "+selected.gold.to_s+" gold.")
          #prompt.yes?("Proceed?")
        else
          puts("The shop doesn't have enough funds")
          puts object.attributes
          #prompt.yes?("Proceed?")
        end
      end
    end

    def buy_item(object)
      prompt=TTY::Prompt.new
      temp_dict={}
      object.inventory.slots.each_with_index do |item, i|
        temp_dict[(i+1).to_s+". "+item.name+" Gold: "+item.gold.to_s]=item
      end
      if temp_dict.size==0
        puts "SHOP EMPTY"
        #prompt.yes?("Proceed?")
        return
      end
      selected=prompt.select("__Shop inventory__", temp_dict)
      choice_=prompt.select(selected, %w(Buy Back))

      if choice_=="Buy"
        if self.inventory.gold>=selected.gold
          self.lose_gold(selected.gold)
          self.take_item(selected)
          puts "Item aquired, you spent "+selected.gold.to_s+" gold."
          #prompt.yes?("Proceed?")
        else
          puts "Not enough gold!"
          #prompt.yes?("Proceed?")
        end
      end
    end

    def deal_damage(enemy)
      dmg=enemy.take_damage(@damage)
      @stats.damage_dealt+=dmg
      dmg
    end

    def take_damage(dmg)
      if dmg<0 then dmg=0 end
      @stats.damage_taken+=dmg
      @health=@health-dmg
      if @health<=0
        @dead = true
        @health = 0
      end
    end

    def choose_quest(object)
      prompt=TTY::Prompt.new
      temp_dict={}
      object.quests.each_with_index do |quest, i|
        temp_dict[(i+1).to_s+". "+quest.name+" Description: "+quest.description]=quest
      end
      if temp_dict.size==0
        puts "NO QUESTS AVAILABLE"
        #prompt.yes?("Proceed?")
        return
      end
      selected=prompt.select("__Quests__", temp_dict)
      choice_=prompt.select(selected, %w(Accept Back))
      if choice_=="Accept"
        self.accept_quest(selected)
      end
    end

    def accept_quest(quest)
      @quests.append(quest)
      quest.accept_quest(self)

    end

    def add_ability(ability)
      @abilities.append(ability)
    end
    def command_substitution(ability)
      #IF COMMAND CONTAINS EXPRESSION SUBSTITUTION
      if ability.command.split(" ")[1].start_with?("#")
        ability.command=ability.command.split(" ")
        ability.command[1]=ability.command[1][16...-1].to_i*self.damage
        ability.command=ability.command.join(" ")
      end
      ability
    end
    def list_abilities
      temp_dict={}
      @abilities.each_with_index do |ability, i | ability
      ability=command_substitution(ability)
      temp_dict[(i+1).to_s+". "+ability.name+" Desc: "+ability.command.to_s]=ability
      end

      selected=TTY::Prompt.new.select("Choose ability", temp_dict)
      return selected
    end

    def move_to (pos_x, pos_y)
      if States::Base.inside_margin?(pos_x, pos_y) and not Map::Base.check_collision(pos_x, pos_y) then
        @pos_x = pos_x
        @pos_y = pos_y
        return true
      end
      return false
    end

    def is_dead
      @dead
    end

    def respawn
      @pos_y=0
      @pos_x=0
      @inventory.reset_inv
      @health=100
      @dead=false
    end

    def fight(enemy, object_x, object_y)
      prompt=TTY::Prompt.new
      loop do
        parry=false

        #LISTS PLAYER'S AND ENEMY'S HP
        puts "\n\n"+@name+"("+@health.to_s+")"" vs "+enemy.name+"("+enemy.health.to_s+")"+"\n\n"

        action = prompt.select("Choose action", %w(Attack Parry Escape))

        #PLAYER'S TURN
        if action=="Attack"
          puts "\e[H\e[2J"

          choice=self.list_abilities
          choice.use_ability(self, enemy)

        elsif action=="Parry"
          parry=true
        else
          States::Base.game(self)
          return
        end

        #CHECK IF ENEMY DEAD
        if enemy.is_dead
          puts "\e[H\e[2J"
          puts "You won!"
          @stats.kills+=1
          @stats.killed.append(enemy)

          if enemy.is_a?(NPC::Enemy)
            puts "Gained 30XP and 100 gold!"
            #prompt.yes?("Proceed?")
            self.gain_xp(30)
            self.gain_gold(100)
          else
            puts "Gained 120XP and 500 gold!"
            #prompt.yes?("Proceed?")
            self.gain_xp(120)
            self.gain_gold(500)
          end

          Map::Base.change_pixel(object_x,object_y,".")
          States::Base.game(self)
          return
        end

        #ENEMY TURN
        dmg = enemy.deal_damage(self, parry)
        puts "You recieved "+dmg.to_s+" DMG."
        puts "You have "+@health.to_s+" HP remaining."
        if self.is_dead
          choice=prompt.select("YOU DIED", %w(Respawn Quit))
          if choice=="Respawn"
            self.respawn
            return
          else
            puts "Exiting"
            exit
          end
        end
      end
    end

    def self.check_object_class(object)
      if object.is_a?(NPC::Enemy) or object.is_a?(NPC::EnemyBoss)
        choices = %w(Fight Back)
      end
      if object.is_a?(Item::Consumable) or object.is_a?(Item::Weapon)
        choices = %w(Take Use Back)
      end
      if object.is_a?(NPC::QuestGiver)
        choices = %w(Quests Back)
      end
      if object.is_a?(NPC::Shop)
        choices = %w(Buy Sell Back)
      end
      choices
    end

    def determine_type_and_use(object, object_x, object_y)
      prompt=TTY::Prompt.new
      if object.item_type=="Consumable"
        self.use_item(object)
        Map::Base.change_pixel(object_x,object_y,".")
      else
        if object.req_lvl<=self.level
          self.equip_weapon(object)
          Map::Base.change_pixel(object_x,object_y,".")
        else
          puts "You need to be at least level "+object.req_lvl.to_s+" to use this."
          #prompt.yes?("Proceed?")
        end
      end
    end

    def show_quests
      @quests.each_with_index do |q, i| q
      puts (i+1).to_s+". "+q.name+" Desc: "+q.description
      end
      if @quests.size==0 then puts "No quests currently." end
        #TTY::Prompt.new.yes?("Proceed?")
    end

    def interact(object)
      if object.nil? then return end

      object_x=object[1]
      object_y=object[2]
      object=object[0]

      puts object.attributes

      prompt = TTY::Prompt.new
      choices = Player::Base.check_object_class(object)

      choice = prompt.select("Choose action", choices)

      if choice=="Fight" then
        self.fight(object, object_x, object_y)
        return

      elsif choice=="Take"
        self.take_item(object)
        #prompt.yes?("Proceed?")
        Map::Base.change_pixel(object_x,object_y,".")
        return

      elsif choice=="Use"
        self.determine_type_and_use(object, object_x, object_y)
        return
      elsif choice=="Buy"
        self.buy_item(object)
        return
      elsif choice=="Sell"
        self.sell_item(object)
        return
      elsif choice=="Quests"
        object.display_quests
        self.choose_quest(object)
      else
        States::Base.game(self)
        return
      end

    end
  end
end
module Map
  class Base
    @@map=[]
    @@count=0
    @@id_default=1
    @@instances=[]

    #PREVIOUS PLAYER POSITION
    @@prev_x=0
    @@prev_y=0
    attr_reader :width, :height, :map

    def initialize(name, width, height, objects, out, id = @@id_default)
      @@id=id
      @@name=name
      @@width=width
      @@height=height
      @@objects=objects
      @@out=out
      if @@id == @@id_default then @@id_default+=1 end
      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end
    def self.load_map(map)
      @@map=map
    end
    def self.count
      @@count
    end
    def self.entire_map
      @@map
    end
    def self.width
      @@width
    end
    def self.height
      @@height
    end
    def self.objects
      @@objects
    end
    def self.change_pixel(x,y,pixel)
      @@map[x][y]=pixel
    end

    def self.render(player)
      pos_x=player.pos_x
      pos_y=player.pos_y
      map_marker=player.map_marker
      #COUNT STEPS
      if pos_x!=@@prev_x or pos_y!=@@prev_y
        player.stats.steps+=1
      end
      x=0, y=0
      #ENFORCING WINDOW SIZE AND DRAWING MAP
      if pos_x<10 then x=0
      elsif Map::Base.height-pos_x<10
        x=Map::Base.height-20
      else x=pos_x-9
      end
      if pos_y<10 then y=0
      elsif Map::Base.width-pos_y<10
        y=Map::Base.width-20
      else y=pos_y-9
      end

      restricted=@@map.map(&:clone)
      restricted[pos_x][pos_y]=map_marker
      restricted=restricted[x,20]
      restricted.each_with_index do |line, index|
        puts line[y,20]
      end
      return
    end
    def self.add_object(object,pos_x, pos_y)
      if States::Base.inside_margin?(pos_x, pos_y) then
        @@objects.append([object, pos_x, pos_y])
        if object.is_a?(Item::Consumable) then
          @@map[pos_x][pos_y]="▓"
        elsif object.is_a?(Item::Weapon)
          @@map[pos_x][pos_y]="░"
        elsif object.is_a?(NPC::Enemy)
          @@map[pos_x][pos_y]=object.map_marker
        elsif object.is_a?(NPC::EnemyBoss)
          @@map[pos_x][pos_y]=object.map_marker
        elsif object.is_a?(NPC::Shop)
          @@map[pos_x][pos_y]="€"
        elsif object.is_a?(NPC::QuestGiver)
          @@map[pos_x][pos_y]="Q"
        end
      end
    end
    def self.display(object)

    end
    def self.remove_object(object)

    end
    def self.check_collision(pos_x, pos_y)
      return "▓░©®EĐ€Q".include?(@@map[pos_x][pos_y])
    end

  end
end
module NPC
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]

    def attributes
      @atts
    end

    attr_reader :pos_x, :pos_y, :name
    def initialize(name, pos_x, pos_y, id = @@id_default)
      @id=id
      @name=name
      @pos_x=pos_x
      @pos_y=pos_y
      if @id == @@id_default then @@id_default+=1 end
      @@count += 1
      @@instances << self
      @atts = ["Name: "+@name.to_s, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s]
    end
    def self.all
      @@instances.inspect
    end

    def self.count
      @@count
    end
  end
  class Enemy < Base
    attr_accessor :health, :damage, :map_marker
    def initialize(name, pos_x, pos_y, damage, armor, health, inventory, dead, map_marker, image, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @damage=damage
      @armor=armor
      @health=health
      @inventory=inventory
      @dead=dead
      @map_marker=map_marker
      @image=image
      @atts = ["Name: "+@name, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s, "Damage: "+@damage.to_s, "Armor: "+@armor.to_s, "Health: "+@health.to_s,"Inventory: "+@inventory.slots.to_s, "Dead: "+@dead.to_s, "Map marker: "+@map_marker.to_s]
    end
    def is_dead
      @dead
    end
    def deal_damage(player, parry)
      dmg=@damage
      dmg=dmg-player.armor
      if parry
        dmg-=player.damage
      end
      if dmg<0 then dmg=0 end
      player.take_damage(dmg)
      dmg
    end
    def take_damage(dmg)
      dmg=dmg-@armor
      if dmg<0 then dmg=0 end
      @health=@health-dmg
      if @health<=0
        @dead = true
        @health = 0
      end
      dmg
    end
  end
  class EnemyBoss < Base
    attr_accessor :health, :damage, :map_marker
    def initialize(name, pos_x, pos_y, damage, armor, health, inventory, dead, map_marker, image, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @damage=damage
      @armor=armor
      @health=health
      @inventory=inventory
      @dead=dead
      @map_marker=map_marker
      @image=image
      @atts = ["Name: "+@name, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s, "Damage: "+@damage.to_s, "Armor: "+@armor.to_s, "Health: "+@health.to_s,"Inventory: "+@inventory.slots.to_s, "Dead: "+@dead.to_s, "Map marker: "+@map_marker.to_s]

    end
    def is_dead
      @dead
    end
    def deal_damage(player, parry)
      dmg=@damage
      if parry
        dmg-=player.damage
        if dmg<0 then dmg=0 end
      end
      player.take_damage(@damage)
      dmg
    end
    def take_damage(dmg)
      dmg=dmg-@armor
      if dmg<0 then dmg=0 end
      @health=@health-dmg
      if @health<=0
        @dead = true
        @health = 0
      end
      dmg
    end
  end
  class Shop < Base
    attr_reader :inventory
    def initialize(name, pos_x, pos_y, inventory, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @inventory = inventory
      @atts = ["Name: "+@name, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s, "Inventory:\n"+@inventory.pretty_slots.to_s, "\nGold: "+@inventory.gold.to_s]

    end

    def set_items

    end
  end
  class QuestGiver < Base

    attr_accessor :quests

    def initialize(name, pos_x, pos_y, quests, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @quests = quests
      @atts = ["Name: "+@name.to_s, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s, "Quests: "+@quests.to_s]
    end
    def display_quests
      @quests.each_with_index do |quest, i | quest
      puts (i+1).to_s+". "+quest.name+" Description: "+quest.description
      end
    end
  end

end
module Quest
  class Base
    attr_accessor :name, :description, :command, :reward_gold, :reward_xp, :kills, :killed, :gold_collected, :gold_spent, :items_collected, :items, :steps, :damage_dealt, :damage_taken, :healed, :xp_gained
    @@count=0
    @@id_default=1
    @@instances=[]

    def initialize(name, description, command, reward_gold, reward_xp)
      @name=name
      @description=description
      @command=command
      @reward_gold=reward_gold
      @reward_xp=reward_xp

      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def self.count
      @@count
    end

    def accept_quest(player)
      @kills=player.stats.kills.clone
      @killed=player.stats.killed.clone
      @gold_collected=player.stats.gold_collected.clone
      @gold_spent=player.stats.gold_spent.clone
      @items_collected=player.stats.items_collected.clone
      @items=player.stats.items.clone
      @steps=player.stats.steps.clone
      @damage_dealt=player.stats.damage_dealt.clone
      @damage_taken=player.stats.damage_taken.clone
      @healed=player.stats.healed.clone
      @xp_gained=player.stats.xp_gained.clone
    end

    def check_if_complete(player)
      #keywords="Kill,Acquire,Spend,Gain,Walk,Deal"
      #puts @command
      #puts @killed.size
      #TTY::Prompt.new.yes?("amount i playersteps")
      amount=@command[1].to_i
      if @command[0]=="Kill"
        if @command[2]=="NPC"
          return amount<=player.stats.kills-@kills
        elsif @command[2]=="Enemy"
          count=0
          player.stats.killed.each_with_index do |mob, i| mob
          #puts mob.class
          if i<@killed.size then next end
          if mob.class.to_s=="NPC::Enemy" then count+=1 end
          end
          #puts count
          #puts player.stats.killed
          return count>=amount
        elsif @command[2]=="EnemyBoss"
          count=0
          player.stats.killed[@killed.size...].each do |mob|
            if mob.class.to_s=="NPC::EnemyBoss" then count+=1 end
          end
          return count>=amount
        end
      end
      if @command[0]=="Acquire"
        if command[2]=="Gold"
          return amount<=player.stats.gold_collected-@gold_collected
        end
      end
      if @command[0]=="Spend"
        if command[2]=="Gold"
          return amount<=player.stats.gold_spent-@gold_spent
        end
      end
      if @command[0]=="Gain"
        if command[2]=="XP"
          return amount<=player.stats.xp_gained-@xp_gained
        end
      end
      if @command[0]=="Walk"
        if command[2]=="Step"
          return amount<=player.stats.steps-@steps
        end
      end
      if @command[0]=="Deal"
        if command[2]=="DMG"
          return amount<=player.stats.damage_dealt-@damage_dealt
        end
      end
      if @command[0]=="Take"
        if command[2]=="DMG"
          return amount<=player.stats.damage_taken-@damage_taken
        end
      end
    end
  end
end
module States
  class Base
    def self.inside_margin?(x, y)
      x>=0 and x<Map::Base.height and y>=0 and y<Map::Base.width
    end
    def self.special_char?(x, y)
      "▓░©®EĐ€Q".include? Map::Base.entire_map[x][y]
    end
    def self.main_menu(player)
      prompt=TTY::Prompt.new
      choices = %w(Inventory Back Exit)
      results = prompt.select("__Menu__", choices)
      if results=='Back'
      elsif results=='Exit'
        puts 'Exiting'
        exit
      elsif results=='Inventory'
        return Game.open_inventory(player)
      end
    end

    def self.near_object(x, y)
      if inside_margin?(x, y) and special_char?(x,y)
        Map::Base.objects.each do |o|
          if o[1]==x and o[2]==y
            if @@object_count==1 then puts "To interact with object press the corresponding function key." end
            puts "F"+@@object_count.to_s+" "+o[0].name.to_s+" Type: "+o[0].class.to_s
            @@objects_near.append(o)
            return true
          end
        end
      end
    end

    def self.game(player)

      #RENDER MAP
      puts Map::Base.render(player)

      #####CHECK IF PLAYER NEAR OBJECTS
      @@object_count=1
      @@objects_near=[]
      if near_object(player.pos_x-1, player.pos_y) then @@object_count+=1 end
      if near_object(player.pos_x+1, player.pos_y) then @@object_count+=1 end
      if near_object(player.pos_x, player.pos_y-1) then @@object_count+=1 end
      if near_object(player.pos_x, player.pos_y+1) then @@object_count+=1 end

    end

    def self.objects_near
      @@objects_near
    end
  end
end
module Abilities
  class Base

    attr_accessor :name, :damage, :command

    def initialize(name, damage, command)
      @name=name
      @damage=damage
      @command=command
    end

    def use_ability(player, enemy)
      @command=@command.split(" ")
      #DEAL DAMAGE
      if @command[0]=="Deal"
        crit=0
        bonus=0

        #CHECK FOR EXPRESSION SUBSTITUTION
        if @command[1].start_with?("#")
          @command[1]=@command[1][16...-1].to_i*player.damage
        end
        #CHECK FOR BONUS DAMAGE OR CRIT
        if @command[3]=="+"
          if @command[4].end_with?("%")
            percent=@command[4][0...-1].to_f/100
            Random.new.rand<=percent ? crit=1 : crit=0
          else
            bonus=@command[4]
          end
        end
        old_damage=player.damage.clone
        #DEAL BASE DAMAGE
        if @command[1]=="Base"
          player.damage+=player.damage*crit+bonus
          #DEAL *AMOUNT* DAMAGE
        else
          player.damage=@command[1].to_i + @command[1].to_i * crit + bonus
        end

        dmg=player.deal_damage(enemy)
        puts "You dealt "+dmg.to_s+" DMG."
        puts "Enemy has "+enemy.health.to_s+" HP remaining."
        #TTY::Prompt.new.yes?("Proceed?")
        player.damage=old_damage

        #HEAL
      elsif @command[0]=="Heal"
        #HEAL *AMOUNT*% DAMAGE
        if @command[1].end_with?("%")
          healed=(@command[1][0...-1].to_f/100*player.health).to_i
          player.health+=healed
          puts "You healed "+healed.to_s+" HP."
          #HEAL *AMOUNT* DAMAGE
        else
          healed=@command[1].to_i
          player.health+=@command[1].to_i
          puts "You healed "+healed.to_s+" HP."
        end
        puts "Your HP is "+player.health.to_s+" HP."
        #TTY::Prompt.new.yes?("Proceed?")
      end
      @command=@command.join(" ")
    end
  end
end
