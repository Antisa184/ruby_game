module Map
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]
    def initialize(name, width, height, objects, out, id = @@id_default)
      @id=id, @name=name, @width=width, @height=height, @objects=objects, @out=out
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

    def render()

    end
    def add_object(object)

    end
    def display(object)

    end
    def remove_object(object)

    end
    def check_collision(pos_x, pos_y)

    end

  end
end
