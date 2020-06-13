# frozen_string_literal: true

RSpec.describe RailwaySimulator::Train do
  let(:stations) do
    (1..10).map { |i| RailwaySimulator::Station.new("Станция #{i}") }
  end

  let(:start_station) { stations.first }
  let(:end_station)   { stations.last }
  let(:way_stations)  { stations[1..-2] }
  let(:carriage)      { RailwaySimulator::Carriage.new 'Вагон' }

  let(:route) do
    route = RailwaySimulator::Route.new(
      name: 'Маршрут 1',
      start_station: start_station,
      end_station: end_station
    )
    way_stations.each { |station| route.add_way_station station }
    route
  end

  subject { described_class.new('GD2-L1') }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should iterating by carriages' do
    subject.add_carriage carriage
    carriages_names = subject.carriages(&:name)

    expect(carriages_names).to eq([carriage.name])
  end

  it 'should raise ArgumentError if route has wrong type' do
    expect { subject.assign_route(Object.new) }
      .to raise_error(ArgumentError)
  end

  context 'train logic tests' do
    before { subject.assign_route route }

    it 'should have company_name accessor' do
      expect(subject.company_name).to eq(nil)

      expect { subject.company_name = 'Name' }
        .to change(subject, :company_name)
        .from(nil)
        .to('Name')
    end

    it 'should correct return current station' do
      expect(subject.current_station).to eq(start_station)
    end

    it 'should correct return next station' do
      expect(subject.next_station).to eq(way_stations.first)
    end

    it 'should correct return previous station' do
      expect(subject.previous_station).to eq(nil)
    end

    it 'should speed up' do
      expect { subject.speed_up }
        .to change(subject, :speed)
        .from(0)
        .to(RailwaySimulator::Train::MAX_SPEED)
    end

    it 'should brake' do
      subject.speed_up
      expect { subject.brake }
        .to change(subject, :speed)
        .from(RailwaySimulator::Train::MAX_SPEED)
        .to(0)
    end

    it 'should raise ArgumentError if carriage has wrong type' do
      expect { subject.add_carriage(Object.new) }
        .to raise_error(ArgumentError)
    end

    it 'should attach carriage' do
      expect { subject.add_carriage(carriage) }
        .to change(subject, :carriages_count)
        .from(0)
        .to(1)
      expect(subject.carriages).to eq([carriage])
    end

    it 'should not attach carriage if speed > 0' do
      subject.speed_up
      expect { subject.add_carriage(carriage) }
        .not_to change(subject, :carriages_count)
    end

    it 'should detach carriage' do
      subject.add_carriage(carriage)
      expect { subject.remove_carriage(carriage) }
        .to change(subject, :carriages_count)
        .from(1)
        .to(0)
      expect(subject.carriages).to eq([])
    end

    it 'should not detach carriage if speed > 0' do
      subject.add_carriage(carriage)
      subject.speed_up
      expect { subject.remove_carriage(carriage) }
        .not_to change(subject, :carriages_count)
    end

    10.times do
      context 'train move tests' do
        before { subject.speed_up }

        it 'should move ahead to next station' do
          rand(1..stations.count - 2).times { subject.move_ahead }
          current_station = subject.current_station
          next_station    = subject.next_station

          expect { subject.move_ahead }
            .to change(subject, :current_station)
            .from(current_station)
            .to(next_station)
        end

        it 'should move back to previous station' do
          rand(1..stations.count - 2).times { subject.move_ahead }
          current_station = subject.current_station
          prev_station    = subject.previous_station

          expect { subject.move_back }
            .to change(subject, :current_station)
            .from(current_station)
            .to(prev_station)
        end
      end
    end
  end
end
