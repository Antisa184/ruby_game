module Inventory
  class Base
    attr_reader :id, :max_slots, :slots, :gold
    @@count=0
    @@id_default=1
    @@instances=[]

    def initialize(max_slots, slots, gold, id = @@id_default)
      @id=id, @max_slots=max_slots, @slots=slots, @gold=gold
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

    def item_remove(item)
      @slots.each_with_index do |items, i| items
        if item.id == items.id
          @slots.delete_at(i)
          return
        end
      end
    end
    def item_add(item)
      @slots.append(item)
    end
    def upgrade_slots(max_slots)
      @max_slots = max_slots
    end
  end
end
