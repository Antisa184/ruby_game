require 'rspec'
require 'spec_helper'

describe 'Quest' do
  before do
    @player = Player::Base.new
    @quest = Quest::Base.new

  end


  context 'when check_if_complete' do
    before(:example) do
      @quest.accept_quest(@player)
    end
    context 'when command Kill 2 Enemy' do
      before(:example) do
        @quest.command=["Kill","2", "Enemy"]
        @player.stats.killed=[]
        @player.stats.killed.append(NPC::Enemy.new)
        @player.stats.killed.append(NPC::Enemy.new)
        puts @player.stats.killed
      end
      it 'should return true' do
        expect(@quest.check_if_complete(@player)).to eq(true)
      end
    end

    context 'when command Kill 2 EnemyBoss' do
      context "when 2 Enemy in stats" do
        before(:example) do
          @quest.command=["Kill","2", "EnemyBoss"]
          @player.stats.killed=[]
          @player.stats.killed.append(NPC::Enemy.new)
          @player.stats.killed.append(NPC::Enemy.new)
        end
        it 'should return false' do
          expect(@quest.check_if_complete(@player)).to eq(false)
        end
      end

      context "when 2 EnemyBoss in stats" do
        before(:example) do
          @quest.command=["Kill","2", "EnemyBoss"]
          @player.stats.killed=[]
          @player.stats.killed.append(NPC::EnemyBoss.new)
          @player.stats.killed.append(NPC::EnemyBoss.new)
        end
        it 'should return true' do
          expect(@quest.check_if_complete(@player)).to eq(true)
        end
      end
    end

    context 'when command Acquire 100 XP' do
      before(:example) do
        @quest.command=["Gain","100", "XP"]
        @player.gain_xp(100)
      end
      it 'should return true' do
        expect(@quest.check_if_complete(@player)).to eq(true)
      end
    end

    context 'when command Walk 100 Step' do
      before(:example) do
        @quest.command=["Walk","100", "Step"]
        @player.stats.steps=100
      end
      it 'should return true' do
        expect(@quest.check_if_complete(@player)).to eq(true)
      end
    end

    context 'when command Deal 100 damage' do
      before(:example) do
        @quest.command=["Deal","100", "DMG"]
        @player.damage = 102
        @enemy = NPC::Enemy.new
        @enemy.health=102
        @player.deal_damage(@enemy)
      end
      it 'should return true' do
        expect(@quest.check_if_complete(@player)).to eq(true)
      end
    end

    context 'when command Take 100 DMG' do
      before(:example) do
        @quest.command=["Take","100", "DMG"]
        @player.health = 110
        @player.take_damage(100)
      end
      it 'should return true' do
        expect(@quest.check_if_complete(@player)).to eq(true)
      end
    end
  end
end