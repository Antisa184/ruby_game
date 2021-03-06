module Inventory
  class Base
    attr_reader :id, :max_slots, :slots, :gold
    @@count=0
    @@id_default=1
    @@instances=[]

    def initialize(max_slots=10, slots=[], gold=100, id = @@id_default)
      @id=id
      @max_slots=max_slots
      @slots=slots
      @gold=gold
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

    def pretty_slots
      slots_string=""
      @slots.each_with_index do |item, i| item
        slots_string+=(i+1).to_s+". "+item.attributes.to_s+"\n"
                                            ##puts (i+1).to_s+". "+item.attributes.to_s
      end
      slots_string
    end
    def reset_inv
      @slots=[]
      @gold=0
    end

    def gain_gold(gold)
      @gold+=gold
    end
    def lose_gold(gold)
      @gold-=gold
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
      if @slots.size == @max_slots
        puts "Inventory is full!"
        return 0
      end
      @slots.append(item)
      return 1
    end
    def upgrade_slots(max_slots)
      @max_slots = max_slots
    end
  end
end
