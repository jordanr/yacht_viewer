require 'yacht_bot'
class VesselsController < ApplicationController

  def show
    @vessel = Vessel.find(params[:id])

    # populate?
    @vessel = YachtBot.find(@vessel.uscg_id) unless @vessel.builder

    # set marker on map
    vessel = @vessel
    latlon = vessel.latlon
    if latlon
      marker = GMarker.new(latlon, :title => description(vessel), :info_window =>long_description(vessel), :icon=>@icon)
      @map.declare_init(marker, "vessel_marker")
      @map.overlay_init(marker)
      @map.center_zoom_on_points_init(latlon)
      @map.record_init("GEvent.trigger(vessel_marker,'click');")
    end
  end

  # claim your listing PIN code
  def claim
  end
  def edit
  end
  def update
  end
end
