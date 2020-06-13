# frozen_string_literal: true

RSpec.describe RailwaySimulator::Station do
  let(:station_name) { 'Тестовая стацния' }
  subject { described_class.new(station_name) }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should take train' do
    subject.take_train(RailwaySimulator::Train.new('GD2-L1'))
    expect(subject.trains.count).to eq(1)
  end

  context 'trains processing' do
    let(:passenger_train) { RailwaySimulator::PassengerTrain.new('GD2-L1') }
    let(:freight_train)   { RailwaySimulator::FreightTrain.new('GD2-L2') }

    before do
      subject.take_train(passenger_train)
      subject.take_train(freight_train)
    end

    it 'should raise ArgumentError for wrong arguments' do
      expect { subject.take_train(Object.new) }
        .to raise_error(ArgumentError)
    end

    it 'should return all trains' do
      expect(subject.trains).to eq([passenger_train, freight_train])
    end

    it 'should process under trains' do
      trains_numbers = subject.trains(&:number)

      expect(trains_numbers)
        .to eq([passenger_train.number, freight_train.number])
    end

    it 'should return only passenger trains' do
      expect(subject.trains(for_type: RailwaySimulator::PassengerTrain))
        .to eq([passenger_train])
    end

    it 'should return only passenger trains' do
      expect(subject.trains(for_type: RailwaySimulator::FreightTrain))
        .to eq([freight_train])
    end

    it 'should send train' do
      subject.send_train(passenger_train)
      expect(subject.trains).to eq([freight_train])
    end
  end
end
