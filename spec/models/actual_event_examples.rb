shared_examples 'an actual event' do |for_class: :event|
  let(:event) { FactoryBot.build(for_class) }
  it 'should not validate without selection_type' do
    event.selection_type = nil
    expect(event.valid?).to eq(false)
  end

  it 'should have an attribute deadline' do
    date = Date.tomorrow
    expect(event.deadline).to eq date

    event.deadline = nil
    expect(event).not_to be_valid
  end

  it 'should have an attribute startdate' do
    date = Date.current + 2
    expect(event.startdate).to eq date

    expect(event).to be_valid
    event.startdate = nil
    expect(event).not_to be_valid
  end

  it 'should have an attribute enddate' do
    date = Date.current + 3
    expect(event.enddate).to eq date

    expect(event).to be_valid
    event.enddate = nil
    expect(event).not_to be_valid
  end

  it 'should not be possible to have an enddate, that is before the startdate' do
    expect(event).to be_valid
    event.enddate = Date.current
    event.startdate = Date.current + 1
    expect(event).not_to be_valid
  end

  it 'should be possible to get the duration in day of a event' do
    expect(event.duration).to eq(2)
  end
end
