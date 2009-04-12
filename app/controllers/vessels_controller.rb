class VesselsController < ApplicationController

  def show
    @vessel = Vessel.find_and_populate(params[:id])

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
    @vessel = Vessel.find_and_populate(params[:id])

    # set marker on map
    vessel = @vessel
    latlon = vessel.latlon
    if latlon
      marker = GMarker.new(latlon, :title => description(vessel), :info_window =>long_description(vessel), :icon=>@icon, :draggable=>true)
      @map.declare_init(marker, "vessel_marker")
      @map.overlay_init(marker)
      @map.center_zoom_on_points_init(latlon)
      @map.record_init("GEvent.trigger(vessel_marker,'click');")
      @map.record_init("GEvent.addListener(vessel_marker, 'dragstart', function() { map.closeInfoWindow(); });")
      @map.record_init("GEvent.addListener(vessel_marker, 'dragend', function() { var latlon = vessel_marker.getLatLng(); 
										  document.getElementById('vessel_latitude').value = latlon.lat();
										  document.getElementById('vessel_longitude').value = latlon.lng();
										});")
    end
  end
  def update
    vessel = Vessel.find(params[:id])
    if vessel.update_open_attributes(params[:vessel])
      redirect_to vessel_path(vessel)
    else
      flash[:error] = "Error saving #{vessel.name}"
      redirect_to edit_vessel_path(vessel)
    end
  end
end
