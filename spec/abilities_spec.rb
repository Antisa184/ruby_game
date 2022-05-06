require 'rspec'
require 'spec_helper'

describe 'Abilities' do
  before do
    @player=Player::Base.new
    @stats=Player::Stats.new
    @enemy=NPC::Enemy.new
    @ability=Abilities::Base.new
  end

  after do
    # Do nothing
  end

  context 'when use_ability' do
    context 'when ability deals 5 dmg' do
      before(:example) do
        @ability.command="Deal 5 DMG"
        @ability.use_ability(@player, @enemy)
      end
      it 'deals 3 damage to enemy' do
        expect(@enemy.health).to eq(27)
      end
    end

    context 'when ability deals double (10) dmg' do
      before(:example) do
        @ability.command="Deal #/player.damage*2/ DMG"
        @ability.use_ability(@player, @enemy)
      end
      it 'deals 8 damage to enemy' do
        expect(@enemy.health).to eq(22)
      end
    end

    context 'when ability deals 5 dmg + 100% crit' do
      before(:example) do
        @ability.command="Deal 5 DMG + 100% Crit"
        @ability.use_ability(@player, @enemy)
      end
      it 'deals 8 damage to enemy' do
        expect(@enemy.health).to eq(22)
      end
    end

    context 'when ability heals for 5 hp' do
      before(:example) do
        @ability.command="Heal 5 HP"
        @ability.use_ability(@player, @enemy)
      end
      it 'heals for 5 HP' do
        expect(@player.health).to eq(105)
      end
    end

    context 'when ability heals for 50% HP' do
      before(:example) do
        @ability.command="Heal 50% HP"
        @ability.use_ability(@player, @enemy)
      end
      it 'heals for 50 HP' do
        expect(@player.health).to eq(150)
      end
    end
  end
end