module Player
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]

    attr_reader :pos_x, :pos_y, :map_marker, :health, :equipped_weapon, :xp, :level, :damage, :armor

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
    end
    def self.count
      @@count
    end
    def equip_weapon (weapon)
      @equipped_weapon = weapon
      @damage = weapon.damage
    end
    def take_item (item)
      @inventory.item_add(item)
      puts @inventory.slots
    end
    def use_item (item)
      #SMALL POTION
      if item.id==1
        @health+=30
      #LARGE POTION
      elsif item.id==2
        @health+=60
      #SMALL ARMOR
      elsif item.id==3
        @armor+=2
      #LARGE ARMOR
      elsif item.id==4
        @armor+=5
      end


    end
    def sell_item (item)

    end
    def buy_item (item)

    end
    def drop_item (item)

    end
    def respawn

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
        choices = %w(Fight Back)
      end
      if object[0].is_a?(NPC::Shop)
        choices = %w(Fight Back)
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
            puts "Gained 30XP!"
            prompt.yes?("Proceed?")
            self.gain_xp(30)
            Map::Base.change_pixel(object[1],object[2],".")
            States::Base.game(self)
            return
          end

          #ENEMY TURN
          dmg = object[0].deal_damage(self, parry)
          puts "You recieved "+dmg.to_s+" DMG."
          puts "You have "+@health.to_s+" HP remaining."
        end
      elsif choice[0]=="Take"
        self.take_item(object[0])
        Map::Base.change_pixel(object[1],object[2],".")
        return
      elsif choice[0]=="Use"
        if object[0].item_type=="Consumable"
          self.use_item(object[0])
        else
          self.equip_weapon(object[0])
        end
      else
        States::Base.game(self)
        return
      end

    end
  end
end
