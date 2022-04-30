module Player
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]
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
    def accept_quest(quest)
      @quests.add(quest)
    end
    def move_to (pos_x, pos_y)
      @pos_x = pos_x
      @pos_y = pos_y
    end
    def is_dead
      @dead
    end
    def interact(object)

    end
  end
end
