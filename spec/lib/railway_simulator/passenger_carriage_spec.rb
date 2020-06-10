# frozen_string_literal: true

RSpec.describe RailwaySimulator::PassengerCarriage do
  subject { described_class.new name: 'Вагон' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  context 'change places' do
    it 'should change places' do
      expect { subject.take_place }
        .to change(subject, :occupied_places)
        .from(0)
        .to(1)
    end

    it 'should not change places' do
      50.times { subject.take_place }

      expect { subject.take_place }
        .to_not change(subject, :occupied_places)
    end
  end
end
