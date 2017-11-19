class StaticPagesController < ApplicationController
  def show
    render params[:static_page]
  end
end
