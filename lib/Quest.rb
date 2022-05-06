module Quest
  class Base
    attr_accessor :name, :description, :command, :reward_gold, :reward_xp, :kills, :killed, :gold_collected, :gold_spent, :items_collected, :items, :steps, :damage_dealt, :damage_taken, :healed, :xp_gained
    @@count=0
    @@id_default=1
    @@instances=[]

    def initialize(name="Quest", description="Desc", command="Do something", reward_gold=10, reward_xp=10)
      @name=name
      @description=description
      @command=command
      @reward_gold=reward_gold
      @reward_xp=reward_xp

      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def self.count
      @@count
    end

    def accept_quest(player)
      @kills=player.stats.kills.clone
      @killed=player.stats.killed.clone
      @gold_collected=player.stats.gold_collected.clone
      @gold_spent=player.stats.gold_spent.clone
      @items_collected=player.stats.items_collected.clone
      @items=player.stats.items.clone
      @steps=player.stats.steps.clone
      @damage_dealt=player.stats.damage_dealt.clone
      @damage_taken=player.stats.damage_taken.clone
      @healed=player.stats.healed.clone
      @xp_gained=player.stats.xp_gained.clone
    end

    def check_if_complete(player)
      #keywords="Kill,Acquire,Spend,Gain,Walk,Deal"
      #puts @command
      #puts @killed.size
      #TTY::Prompt.new.yes?("amount i playersteps")
      amount=@command[1].to_i
      if @command[0]=="Kill"
        if @command[2]=="NPC"
          return amount<=player.stats.kills-@kills
        elsif @command[2]=="Enemy"
          count=0
          player.stats.killed.each_with_index do |mob, i| mob
          #puts mob.class
          if i<@killed.size then next end
            if mob.class.to_s=="NPC::Enemy" then count+=1 end
          end
          #puts count
          #puts player.stats.killed
          return count>=amount
        elsif @command[2]=="EnemyBoss"
          count=0
          player.stats.killed[@killed.size...].each do |mob|
            if mob.class.to_s=="NPC::EnemyBoss" then count+=1 end
          end
          return count>=amount
        end
      end
      if @command[0]=="Acquire"
        if command[2]=="Gold"
          return amount<=player.stats.gold_collected-@gold_collected
        end
      end
      if @command[0]=="Spend"
        if command[2]=="Gold"
          return amount<=player.stats.gold_spent-@gold_spent
        end
      end
      if @command[0]=="Gain"
        if command[2]=="XP"
          return amount<=player.stats.xp_gained-@xp_gained
        end
      end
      if @command[0]=="Walk"
        if command[2]=="Step"
          return amount<=player.stats.steps-@steps
        end
      end
      if @command[0]=="Deal"
        if command[2]=="DMG"
          return amount<=player.stats.damage_dealt-@damage_dealt
        end
      end
      if @command[0]=="Take"
        if command[2]=="DMG"
          return amount<=player.stats.damage_taken-@damage_taken
        end
      end
    end
  end
end