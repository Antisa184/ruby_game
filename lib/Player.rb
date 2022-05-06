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
        TTY::Prompt.new.yes?("Proceed?")
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
        prompt.yes?("Proceed?")
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
          prompt.yes?("Proceed?")
        else
          puts("The shop doesn't have enough funds")
          puts object.attributes
          prompt.yes?("Proceed?")
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
        prompt.yes?("Proceed?")
        return
      end
      selected=prompt.select("__Shop inventory__", temp_dict)
      choice_=prompt.select(selected, %w(Buy Back))

      if choice_=="Buy"
        if self.inventory.gold>=selected.gold
          self.lose_gold(selected.gold)
          self.take_item(selected)
          puts "Item aquired, you spent "+selected.gold.to_s+" gold."
          prompt.yes?("Proceed?")
        else
          puts "Not enough gold!"
          prompt.yes?("Proceed?")
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
        prompt.yes?("Proceed?")
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
            prompt.yes?("Proceed?")
            self.gain_xp(30)
            self.gain_gold(100)
          else
            puts "Gained 120XP and 500 gold!"
            prompt.yes?("Proceed?")
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
          prompt.yes?("Proceed?")
        end
      end
    end

    def show_quests
      @quests.each_with_index do |q, i| q
        puts (i+1).to_s+". "+q.name+" Desc: "+q.description
      end
      if @quests.size==0 then puts "No quests currently." end
      TTY::Prompt.new.yes?("Proceed?")
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
        prompt.yes?("Proceed?")
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
