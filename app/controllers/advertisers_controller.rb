class AdvertisersController < ApplicationController
  def index
    marker = GMarker.new(ad_latlon, :title => ad_description, :info_window =>ad_long_description, :draggable=>true, :icon=>@icon)
    @map.declare_init(marker, "ad_marker")
    @map.overlay_init(marker)
    @map.center_zoom_on_points_init(ad_latlon)
    @map.record_init("GEvent.trigger(ad_marker,'click');")
  end

  ###########
  # Frontends
  ##########
  def show
  end

  def new
  end

  def edit
  end

  def delete
  end

  ############
  #  Backends # do a verify PIN before save
  ##############
  def create
  end

  def update
  end

  def destroy
  end
end
