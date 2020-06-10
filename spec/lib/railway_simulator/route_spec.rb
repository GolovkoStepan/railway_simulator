# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe RailwaySimulator::Route do
  let(:name)          { 'Тестовый маршрут' }
  let(:start_station) { RailwaySimulator::Station.new 'Начальная стацния' }
  let(:end_station)   { RailwaySimulator::Station.new 'Конечная стацния' }

  subject do
    described_class.new(
      name: name,
      start_station: start_station,
      end_station: end_station
    )
  end

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should add way station' do
    subject.add_way_station(RailwaySimulator::Station.new('Станция'))
    expect(subject.all_stations.count).to eq(3)
  end

  context 'way stations processing' do
    let(:way_stations) do
      (1..5).map { |i| RailwaySimulator::Station.new"Промежуточная станция #{i}" }
    end

    before { way_stations.each { |station| subject.add_way_station station } }

    it 'should raise ArgumentError for wrong argument' do
      expect { subject.add_way_station(Object.new) }
        .to raise_error(ArgumentError)
    end

    it 'should delete way station' do
      subject.remove_way_station(way_stations.sample)
      expect(subject.all_stations.count).to eq(2 + way_stations.count - 1)
    end
  end
end

# rubocop:enable Metrics/BlockLength
