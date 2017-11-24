# This controller doesn't have a corresponding model and is meant to only serve
# pages that don't contain any dynamic content. Currently, this is only the 'imprint'
# page but later an 'about' page could also be made accessible via this controller

class StaticPagesController < ApplicationController
  def imprint
  end
end
