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
      @atts = ["Name: "+@name, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s]
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
    end
  end
  class Shop < Base
    attr_reader :inventory
    def initialize(name, pos_x, pos_y, inventory, id = @@id_default)
      super(name, pos_x, pos_y, id)
      @inventory = inventory
      @atts = ["Name: "+@name, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s, "Inventory:\n"+@inventory.pretty_slots.to_s]

    end

    def set_items

    end
  end
  class QuestGiver < Base
    def initialize(name, pos_x, pos_y, quests, id = @@id_default)
      super(id, name, pos_x, pos_y)
      @quests = quests
      @atts = ["Name: "+@name, "X: "+@pos_x.to_s, "Y: "+@pos_y.to_s, "Id: "+@id.to_s, "Quests: "+@quests.to_s]
    end
    def display_quests
      @quests.each_with_index do |quest, i | quest
        puts i+". "+quest.name+" Description: "+quest.description
      end
    end
  end

end
