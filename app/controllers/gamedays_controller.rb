class GamedaysController < ApplicationController
  def update
    @gameday = Gameday.find(params[:id])
    @gameday.update(gameday_params)
    redirect_to event_schedule_path(@gameday.event), notice: 'successfully changed gameday date'
  end

  def gameday_params
    params.require(:gameday).permit(:starttime, :endtime, :description)
  end
end
