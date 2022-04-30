module Quest
  class Base
    @@count=0
    @@id_default=1
    @@instances=[]
    def initialize
      super
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
end