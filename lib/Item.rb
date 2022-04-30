module Item
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]
    def initialize(name, description, gold, usable, stackable, count, item_type, rarity, equipped, id = @@id_default)
      @id= id, @name = name, @description = description, @gold = gold,
      @usable = usable, @stackable = stackable, @count = count,
      @item_type = item_type, @rarity = rarity, @equipped = equipped
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
    def initialize(name, description, gold, usable, stackable,
                   count, item_type, rarity, equipped,
                   damage, req_lvl, id = @@id_default)

      super(name, description, gold, usable, stackable,
            count, item_type, rarity, equipped, id)
      @damage = damage
      @req_lvl = req_lvl

    end
  end

  class Consumable < Base
    def initialize(name, description, gold, usable, stackable,
                   count, item_type, rarity, equipped,
                   on_use, id = @@id_default)

      super(name, description, gold, usable, stackable,
            count, item_type, rarity, equipped, id)
      @on_use = on_use
    end
  end
end
