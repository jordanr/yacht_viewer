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
      @map.overlay_init(GMarker.new(latlon, :title => description(vessel), :info_window =>long_description(vessel)))
      @map.center_zoom_on_points_init(latlon)
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
