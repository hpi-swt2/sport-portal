class GamedaysController < ApplicationController
  def update
    @gameday = Gameday.find(params[:id])
    authorize! :update_gameday, @gameday
    if @gameday.update(starttime: Date.strptime(gameday_params[:starttime],'%d.%m.%Y'), endtime: Date.strptime(gameday_params[:endtime], '%d.%m.%Y'))
      redirect_to event_schedule_path(@gameday.event), notice: t('success.updated_gameday_dates')
    end
  end

  def gameday_params
    params.require(:gameday).permit(:starttime, :endtime, :description)
  end
end
