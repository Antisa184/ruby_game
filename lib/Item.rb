module Item
  class Base
    attr_reader :id, :name, :description, :gold, :usable, :stackable, :count, :item_type, :rarity, :equipped
    @@count=0
    @@id_default=1
    @@instances=[]

    def attributes
      @atts
    end

    def initialize(name="Item", description="Desc", gold=10, usable=true, stackable=true, count=1, item_type="Item", rarity=1, equipped=false, id = @@id_default)
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

    attr_reader :id_default, :damage, :req_lvl

    def attributes
      @atts
    end

    def initialize(name="Item", description="Desc", gold=10, usable=true, stackable=true, count=1, item_type="Item", rarity=1, equipped=false,
                   damage=10, req_lvl=1, id = @@id_default)

      super(name, description, gold, usable, stackable,
            count, item_type, rarity, equipped, id)
      @damage = damage
      @req_lvl = req_lvl
      @atts = ["Id: "+@id.to_s, "Name: "+@name, "Desc: "+@description.to_s, "Gold: "+@gold.to_s, "Usable: "+@usable.to_s, "Stackable: "+@stackable.to_s, "Count: "+@count.to_s, "Item type: "+@item_type.to_s, "Rarity: "+@rarity.to_s, "Equipped: "+@equipped.to_s, "Damage: "+@damage.to_s,"Required lvl: "+ @req_lvl.to_s]
    end

  end

  class Consumable < Base

    attr_reader :id_default, :on_use

    def attributes
      @atts
    end

    def initialize(name="Item", description="Desc", gold=10, usable=true, stackable=true, count=1, item_type="Item", rarity=1, equipped=false,
                   on_use="Do something", id = @@id_default)

      super(name, description, gold, usable, stackable,
            count, item_type, rarity, equipped, id)
      @on_use = on_use
      @atts = ["Id: "+@id.to_s, "Name: "+@name, "Desc: "+@description.to_s, "Gold: "+@gold.to_s, "Usable: "+@usable.to_s, "Stackable: "+@stackable.to_s, "Count: "+@count.to_s, "Item type: "+@item_type.to_s, "Rarity: "+@rarity.to_s, "Equipped: "+@equipped.to_s, "On use: "+@on_use.to_s]
    end

  end
end
