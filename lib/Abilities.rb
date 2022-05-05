module Abilities
  class Base

    attr_accessor :name, :damage, :command

    def initialize(name, damage, command)
      @name=name
      @damage=damage
      @command=command
    end

    def use_ability(player, enemy)
      @command=@command.split(" ")
      #DEAL DAMAGE
      if @command[0]=="Deal"
        crit=0
        bonus=0

        #CHECK FOR EXPRESSION SUBSTITUTION
        if @command[1].start_with?("#")
          @command[1]=@command[1][16...-1].to_i*player.damage
        end
        #CHECK FOR BONUS DAMAGE OR CRIT
        if @command[3]=="+"
          if @command[4].end_with?("%")
            percent=@command[4][0...-1].to_f/100
            Random.new.rand<=percent ? crit=1 : crit=0
          else
            bonus=@command[4]
          end
        end
        old_damage=player.damage.clone
        #DEAL BASE DAMAGE
        if @command[1]=="Base"
          player.damage+=player.damage*crit+bonus
        #DEAL *AMOUNT* DAMAGE
        else
          player.damage=@command[1].to_i + @command[1].to_i * crit + bonus
        end

        dmg=player.deal_damage(enemy)
        puts "You dealt "+dmg.to_s+" DMG."
        puts "Enemy has "+enemy.health.to_s+" HP remaining."
        TTY::Prompt.new.yes?("Proceed?")
        player.damage=old_damage

      #HEAL
      elsif @command[0]=="Heal"
        #HEAL *AMOUNT*% DAMAGE
        if @command[1].end_with?("%")
          healed=(@command[1][0...-1].to_f/100*player.health).to_i
          player.health+=healed
          puts "You healed "+healed.to_s+" HP."
        #HEAL *AMOUNT* DAMAGE
        else
          healed=@command[1].to_i
          player.health+=@command[1].to_i
          puts "You healed "+healed.to_s+" HP."
        end
        puts "Your HP is "+player.health.to_s+" HP."
        TTY::Prompt.new.yes?("Proceed?")
      end
      @command=@command.join(" ")
    end
  end
end
