# frozen_string_literal: true

RSpec.describe RailwaySimulator::Carriage do
  subject { described_class.new 'Вагон' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should have company_name accessor' do
    expect(subject.company_name).to eq(nil)

    expect { subject.company_name = 'Name' }
      .to change(subject, :company_name)
      .from(nil)
      .to('Name')
  end

  it 'should validate name field' do
    subject.name = ''

    expect(subject.valid?).to eq false
    expect { subject.validate! }
      .to raise_error(
        RailwaySimulator::Common::Validation::ValidationCustomError
      )
    expect(subject.errors.count).to eq 1
  end
end
