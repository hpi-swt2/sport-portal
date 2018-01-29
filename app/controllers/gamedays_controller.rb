class GamedaysController < ApplicationController
  def update
    @gameday = Gameday.find(params[:id])
    authorize! :update, @gameday
    if @gameday.update(starttime: Date.strptime(gameday_params[:starttime],'%d.%m.%y'), endtime: Date.strptime(gameday_params[:endtime], '%d.%m.%y'))
      redirect_to event_schedule_path(@gameday.event), notice: t('success.updated_gameday_dates')
    else
      redirect_to event_schedule_path(@gameday.event), notice: t('failure.updated_gameday_dates')
    end

  end

  def gameday_params
    params.require(:gameday).permit(:starttime, :endtime, :description)
  end
end
