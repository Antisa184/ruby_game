module Player
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]

    attr_reader :pos_x, :pos_y, :map_marker, :health, :equipped_weapon, :xp, :level, :damage

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

    def self.count
      @@count
    end
    def equip_weapon (weapon)
      @equipped_weapon = weapon
    end
    def use_item (item)

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
      enemy.take_damage(@damage)
    end
    def take_damage(dmg)
      dmg=dmg-@armor
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
      puts "\e[H\e[2J"
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
            deal_damage(object[0])
            puts "You dealt "+@damage.to_s+" DMG."
            puts "Enemy has "+object[0].health.to_s+" HP remaining."

          elsif action[0]=="Parry"
            parry=true
          else
            break
          end

          #ENEMY TURN
          dmg = object[0].deal_damage(self, parry)
          puts "You recieved "+dmg.to_s+" DMG."
          puts "You have "+@health.to_s+" HP remaining."

        end
      end
      Map::Base.change_pixel(object[1],object[2],".")
    end
  end
end
