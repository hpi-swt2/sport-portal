require 'rails_helper'

RSpec.describe GamedaysController, type: :controller do
  let(:gameday){FactoryBot.create(:gameday)}
  let(:new_dates) {{starttime: Date.parse("05.05.2012"),
                    endtime: Date.parse('12.05.2012')}}
  it 'changes the date of a gameday if requested' do
    put :update, params: {id: gameday.id, gameday: new_dates}
    gameday.reload
    expect(gameday.starttime).to eq new_dates[:starttime]
    expect(gameday.endtime).to eq new_dates[:endtime]
  end

  it 'renders the schedule after date change' do
    put :update, params: {id: gameday.id, gameday: new_dates}
    expect(response).to redirect_to(event_schedule_url(gameday.event))
  end
end