module Player
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]

    attr_reader :pos_x, :pos_y, :map_marker, :health, :equipped_weapon, :xp, :level, :damage, :armor, :inventory

    def initialize(name, level, xp, health, damage, armor, pos_x, pos_y, dead, quests, inventory, equipped_weapon, abilities, interacting_with, map_marker, image, id = @@id_default)
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

      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def gain_xp(xp)
      @xp+=xp
      if @xp>29 then @level=2 end
      if @xp>50 then @level=3 end
      if @xp>80 then @level=4 end
      if @xp>120 then @level=5 end
      if @xp>200 then @level=6 end

    end

    def gain_gold(gold)
      @inventory.gain_gold(gold)
    end
    def lose_gold(gold)
      @inventory.lose_gold(gold)
    end
    def self.count
      @@count
    end
    def equip_weapon (weapon)
      @equipped_weapon = weapon
      @damage = weapon.damage
    end
    def take_item (item)
      #puts item.attributes
      @inventory.item_add(item)
        #puts @inventory.slots[0].class
    end
    def use_item (item)
      #SMALL POTION
      if item.id[0]==1
        @health+=30
      #LARGE POTION
      elsif item.id[0]==2
        @health+=60
      #SMALL ARMOR
      elsif item.id[0]==3
        @armor+=2
      #LARGE ARMOR
      elsif item.id[0]==4
        @armor+=5
      end

    end
    def sell_item (item)
      @inventory.gain_gold(item.gold)
      self.drop_item(item)
    end
    def buy_item (item)
      @inventory.lose_gold(item.gold)
      self.take_item(item)
    end
    def drop_item (item)
      @inventory.item_remove(item)
    end
    def respawn
      @pos_y=0
      @pos_x=0
      @inventory.reset_inv
      @health=100
    end
    def deal_damage(enemy)
      dmg=enemy.take_damage(@damage)
      dmg
    end
    def take_damage(dmg)
      if dmg<0 then dmg=0 end
      @health=@health-dmg
      if @health<=0
        @dead = true
        @health = 0
      end
    end
    def accept_quest(quest)
      @quests.add(quest)
    end
    def move_to (pos_x, pos_y)
      if pos_x>=0 and pos_y>=0 and pos_x<Map::Base.height and pos_y<Map::Base.width and not Map::Base.check_collision(pos_x, pos_y) then
        @pos_x = pos_x
        @pos_y = pos_y
      end
    end
    def is_dead
      @dead
    end
    def interact(object)
      if object.nil? then return end
      #puts "\e[H\e[2J"
      puts object[0].attributes

      prompt = TTY::Prompt.new
      if object[0].is_a?(NPC::Enemy) or object[0].is_a?(NPC::EnemyBoss)
        choices = %w(Fight Back)
      end
      if object[0].is_a?(Item::Consumable) or object[0].is_a?(Item::Weapon)
        choices = %w(Take Use Back)
      end
      if object[0].is_a?(NPC::QuestGiver)
        choices = %w(Quests Back)
      end
      if object[0].is_a?(NPC::Shop)
        choices = %w(Buy Sell Back)
      end

      choice = prompt.multi_select("Choose action", choices)

      if choice[0]=="Fight" then
        loop do
          parry=false
          puts "\n\n"+@name+"("+@health.to_s+")"" vs "+object[0].name+"("+object[0].health.to_s+")"+"\n\n"
          choices = %w(Attack Parry Escape)
          action = prompt.multi_select("Choose action", choices)

          #PLAYER'S TURN
          if action[0]=="Attack"
            puts "\e[H\e[2J"
            dmg=deal_damage(object[0])
            puts "You dealt "+dmg.to_s+" DMG."
            puts "Enemy has "+object[0].health.to_s+" HP remaining."

          elsif action[0]=="Parry"
            parry=true
          else
            States::Base.game(self)
            return
          end

          if object[0].is_dead
            puts "\e[H\e[2J"
            puts "You won!"

            if object[0].is_a?(NPC::Enemy)
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

            Map::Base.change_pixel(object[1],object[2],".")
            States::Base.game(self)
            return
          end

          #ENEMY TURN
          dmg = object[0].deal_damage(self, parry)
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

      elsif choice[0]=="Take"
        self.take_item(object[0])
        prompt.yes?("Proceed?")
        Map::Base.change_pixel(object[1],object[2],".")
        return
      elsif choice[0]=="Use"
        if object[0].item_type=="Consumable"
          self.use_item(object[0])
          Map::Base.change_pixel(object[1],object[2],".")
        else
          if object[0].req_lvl<=self.level
            self.equip_weapon(object[0])
            Map::Base.change_pixel(object[1],object[2],".")
          else
            puts "You need to be at least level "+object[0].req_lvl.to_s+" to use this."
            prompt.yes?("Proceed?")
          end

        end
      elsif choice[0]=="Buy"
        temp_dict={}
        object[0].inventory.slots.each_with_index do |item, i|
          temp_dict[(i+1).to_s+". "+item.name]=item
        end
        if temp_dict.size==0
          puts "SHOP EMPTY"
          prompt.yes?("Proceed?")
          #krv_ti_jebem=1
          return
        end
        selected=prompt.multi_select("__Shop inventory__", temp_dict)
        choice_=prompt.select(selected[0], %w(Buy Back))

        if choice_=="Buy"
          if self.inventory.gold>=selected[0].gold
            self.lose_gold(selected[0].gold)
            self.take_item(selected[0])
            puts "Item aquired, you spent "+selected[0].gold.to_s+" gold."
            prompt.yes?("Proceed?")
          else
            puts "Not enough gold!"
            prompt.yes?("Proceed?")
          end
        end
      elsif choice[0]=="Sell"
        temp_dict={}
        self.inventory.slots.each_with_index do |item, i|
          temp_dict[(i+1).to_s+". "+item.name]=item
        end
        if temp_dict.size==0
          puts "INVENTORY EMPTY"
          prompt.yes?("Proceed?")
          #krv_ti_jebem=1
          return
        end
        selected=prompt.multi_select("__Inventory__", temp_dict)
        choice_=prompt.select(selected[0], %w(Sell Back))

        if choice_=="Sell"
          self.gain_gold(selected[0].gold)
          self.drop_item(selected[0])
          puts("Item sold, you gained "+selected[0].gold.to_s+" gold.")
          prompt.yes?("Proceed?")
        end
      else
        States::Base.game(self)
        return
      end

    end
  end
end
