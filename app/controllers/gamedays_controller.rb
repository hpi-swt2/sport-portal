class GamedaysController < ApplicationController
  def update
    @gameday = Gameday.find(params[:id])
    @gameday.update(gameday_params)
    redirect_to event_schedule_path(@gameday.event), notice: t('success.updated_gameday_dates')
  end

  def gameday_params
    params.require(:gameday).permit(:starttime, :endtime, :description)
  end
end
