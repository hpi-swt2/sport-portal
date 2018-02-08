require 'rails_helper'

RSpec.describe GamedaysController, type: :controller do

  let(:user) { user = FactoryBot.create(:user)
  sign_in user
  user }
  let(:gameday) { FactoryBot.create(:gameday) }
  describe '#update' do
    let(:new_dates) { { starttime: '05.05.2012',
                        endtime: '12.05.2012' } }
    let(:invalid_input) { { starttime: 'asdf', endtime: 'dddd' } }

    context 'when user is an organizer' do
      let(:gameday) { gameday = FactoryBot.create(:gameday)
      gameday.event.organizers << Organizer.new(user: user, event: gameday.event)
      gameday
      }

      it 'changes the date of a gameday if requested' do
        put :update, params: { id: gameday.id, gameday: new_dates }
        gameday.reload
		expect(gameday.starttime).to eq Date.strptime(new_dates[:starttime], '%d.%m.%Y').in_time_zone('Berlin')
		expect(gameday.endtime).to eq Date.strptime(new_dates[:endtime], '%d.%m.%Y').in_time_zone('Berlin')
      end

      it 'doesnt change anything with invalid params' do

        expect { put :update, params: { id: gameday.id, gameday: invalid_input } }.to raise_error 'invalid date'
        gamedayreload = Gameday.find(gameday.id)
        expect(gamedayreload.starttime).to eq gameday.starttime
        expect(gamedayreload.endtime).to eq gameday.endtime
      end

      it 'renders the schedule after date change' do
        put :update, params: { id: gameday.id, gameday: new_dates }
        expect(response).to redirect_to(event_schedule_url(gameday.event))
      end
    end

    context 'when user is not an organizer' do
      it 'raises a fobidden' do
        put :update, params: { id: gameday.id, gameday: new_dates }
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
