class WelcomeController < ApplicationController
  def index
          @map = GMap.new("map_div")
          @map.set_map_type_init(GMapType::G_HYBRID_MAP)
          @map.control_init(:map_type => true, :small_zoom => true)
          @map.center_zoom_init([40,-90], 3)

          if params[:query]
            results = Geocoding::get(params[:query], :key=>Ym4r::GmPlugin::ApiKey.get)
            if results.status == Geocoding::GEO_SUCCESS
#              results.each { |coord| puts coord.inspect }
              coord = results.first
              @map.center_zoom_init(coord.latlon, 6)
              vessels = Vessel.find(:all, :conditions=>["location LIKE ?", "%#{params[:query]}%"])
	      title = "Found #{vessels.size} vessels in #{coord.address}"
              info = "<div style='text-align: left'>
Vessel Count: #{vessels.size}<br/>
Location: #{coord.address}<br/>
Latitude: #{coord.latitude}<br/>
Longitude: #{coord.longitude}<br/>
</div>"
              @map.overlay_init(GMarker.new(coord.latlon, :title => title, :info_window => info))
            else
              puts "Geo code failure"
            end
          else
            max = Vessel.count
	    ids = []
	    10.times { |i| ids += [rand(max)] }
            ids.each do |id|
	      vessel = Vessel.find(id)
              @map.overlay_init(GMarker.new(vessel.location, :title => vessel.description, :info_window => vessel.long_description))
            end
          end             
  end 
end
