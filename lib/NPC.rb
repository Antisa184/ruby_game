module NPC
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]
    def initialize(name, pos_x, pos_y, id = @@id_default)
      @id=id, @name=name, @pos_x=pos_x, @pos_y=pos_y
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
  class Enemy < Base
    def initialize(name, pos_x, pos_y, damage, armor, health, inventory, dead, map_marker, image, id = @@id_default)
      super(id, name, pos_x, pos_y)
      @damage=damage, @armor=armor, @health=health, @inventory=inventory
      @dead=dead, @map_marker=map_marker, @image=image
    end
    def is_dead
      @dead
    end
    def deal_damage

    end
  end
  class EnemyBoss < Base
    def initialize(name, pos_x, pos_y, damage, armor, health, inventory, dead, map_marker, image, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @damage=damage, @armor=armor, @health=health, @inventory=inventory
      @dead=dead, @map_marker=map_marker, @image=image
    end
    def is_dead
      @dead
    end
    def deal_damage

    end
  end
  class Shop < Base
    def initialize(name, pos_x, pos_y, inventory, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @inventory = inventory
    end
    def set_items

    end
  end
  class QuestGiver < Base
    def initialize(id, name, pos_x, pos_y, quests)
      super(id, name, pos_x, pos_y)
      @quests = quests
    end
    def display_quests

    end
  end

end
