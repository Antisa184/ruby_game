require 'rspec'
require 'spec_helper'

describe 'Inventory' do
  before do
    @inventory=Inventory::Base.new
    @item=Item::Base.new
  end

  context 'when gain_gold' do
    before(:example) do
      @inventory.gain_gold(10)
    end
    it 'increases gold by 10' do
      expect(@inventory.gold).to eq(110)
    end
  end

  context 'when lose_gold' do
    before(:example) do
      @inventory.lose_gold(10)
    end
    it 'decreases gold by 10' do
      expect(@inventory.gold).to eq(90)
    end
  end

  context 'when item_add' do
    before(:example) do
      @inventory.item_add(@item)
    end
    it 'has 1 item in slots' do
      expect(@inventory.slots.size).to eq(1)
    end
    context 'when item_remove' do
      before(:example) do
        @inventory.item_remove(@item)
      end
      it 'has 0 item in slots' do
        expect(@inventory.slots.size).to eq(0)
      end
    end
  end

  context 'when upgrade_slots' do
    before(:example) do
      @inventory.upgrade_slots(20)
    end
    it 'decreases gold by 10' do
      expect(@inventory.max_slots).to eq(20)
    end
  end
end