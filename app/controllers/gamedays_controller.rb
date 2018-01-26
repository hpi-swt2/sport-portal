class GamedaysController < ApplicationController
  def update_dates
    @gameday = Gameday.find(params[:id])
    @gameday.update(starttime: gameday_params[:starttime], endtime: gameday_params[:endtime])
    redirect_to event_schedule_path(@gameday.event), notice: 'successfully changed gameday date'
  end

  def gameday_params
    params.require(:gameday).permit(:starttime, :endtime, :description)
  end
end