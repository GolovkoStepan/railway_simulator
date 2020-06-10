# frozen_string_literal: true

RSpec.describe RailwaySimulator::CargoCarriage do
  subject { described_class.new name: 'Вагон' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  context 'change volume' do
    it 'should change volume' do
      expect { subject.take_volume(100) }
        .to change(subject, :occupied_volume)
        .from(0)
        .to(100)
    end

    it 'should not change volume' do
      expect { subject.take_volume(1001) }
        .to_not change(subject, :occupied_volume)
    end
  end
end
