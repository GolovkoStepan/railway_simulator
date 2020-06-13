# frozen_string_literal: true

RSpec.describe RailwaySimulator::FreightTrain do
  let(:carriage) { RailwaySimulator::Carriage.new 'Вагон' }

  let(:passenger_carriage) do
    RailwaySimulator::PassengerCarriage.new(name: 'Пассажирский вагон')
  end

  subject { described_class.new 'GD2-L1' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should not attach carriage' do
    expect { subject.add_carriage(carriage) }
      .to raise_error(ArgumentError)
  end

  it 'should not attach passenger carriage' do
    expect { subject.add_carriage(passenger_carriage) }
      .to raise_error(ArgumentError)
  end

  it 'should raise NumberEmpty if number is empty' do
    expect { described_class.new('').validate! }
      .to raise_error(
        RailwaySimulator::Common::Validation::ValidationCustomError
      )
  end

  it 'should raise ArgumentError if route has wrong type' do
    expect { subject.assign_route(Object.new) }
      .to raise_error(ArgumentError)
  end
end
