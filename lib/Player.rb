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
      @level=Initialize::Base.determine_level(@xp)

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
      if @equipped_weapon!=nil
        self.take_item(@equipped_weapon)
        @equipped_weapon=nil
      end
      @equipped_weapon = weapon
      @damage = weapon.damage
    end
    def unequip_weapon
      @equipped_weapon = nil
      @damage = 5
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
    def fight(enemy, object_x, object_y)
      prompt=TTY::Prompt.new
      loop do
        parry=false
        puts "\n\n"+@name+"("+@health.to_s+")"" vs "+enemy.name+"("+enemy.health.to_s+")"+"\n\n"

        action = prompt.select("Choose action", %w(Attack Parry Escape))

        #PLAYER'S TURN
        if action=="Attack"
          puts "\e[H\e[2J"
          dmg=deal_damage(enemy)
          puts "You dealt "+dmg.to_s+" DMG."
          puts "Enemy has "+enemy.health.to_s+" HP remaining."

        elsif action=="Parry"
          parry=true
        else
          States::Base.game(self)
          return
        end

        if enemy.is_dead
          puts "\e[H\e[2J"
          puts "You won!"

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

    def determine_type_and_use(object, object_x, object_y, prompt)
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

    def sell_item(object, prompt)
      temp_dict={}
      self.inventory.slots.each_with_index do |item, i|
        temp_dict[(i+1).to_s+". "+item.name+" Gold: "+item.gold.to_s]=item
      end
      if temp_dict.size==0
        puts "INVENTORY EMPTY"
        prompt.yes?("Proceed?")
        #krv_ti_jebem=1
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
          prompt.yes?("Proceed?")
        end
      end
    end

    def buy_item(object, prompt)
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

    def interact(object)
      if object.nil? then return end
      #puts "\e[H\e[2J"

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
        self.determine_type_and_use(object, object_x, object_y, prompt)
        return
      elsif choice=="Buy"
        self.buy_item(object,prompt)
        return
      elsif choice=="Sell"
        self.sell_item(object, prompt)
        return
      else
        States::Base.game(self)
        return
      end

    end
  end
end
