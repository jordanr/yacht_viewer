class WelcomeController < ApplicationController
  include WelcomeHelper
  def index
          @map = GMap.new("map_div")
          @map.set_map_type_init(GMapType::G_HYBRID_MAP)

	  markers = []
          if params[:query] and params[:query] != ""
	    
	    tokens = params[:query].split(" ")
	    conds = make_conditions(tokens)
            # total num
#            num = Vessel.count(:conditions=> conds)
            @vessels = Vessel.paginate(:all, :conditions=>conds, :page=>params[:page], :order=>'length DESC')

	    # mark each vessel location that's showing
	    @vessels.reverse_each do |vessel|
	      latlon = vessel.latlon
              if latlon
  	        markers += [latlon]	  
                @map.overlay_init(GMarker.new(latlon, :title => description(vessel), :info_window =>long_description(vessel)))
	      end
            end
          else
            max = Vessel.count
	    ids = []
	    Vessel.per_page.times { |i| ids += [rand(max) + 1] }
            @vessels = Vessel.paginate(ids, :page=>params[:page], :order => 'length DESC')
            @vessels.reverse_each do |vessel|
	      latlon = vessel.latlon
              if latlon
  	        markers += [latlon]
                @map.overlay_init(GMarker.new(latlon, :title => description(vessel), :info_window =>long_description(vessel)))
	      end
            end
          end  
	  # just show the markers tightly
	  if markers != []
            @map.center_zoom_on_points_init(*markers) 
	  else
            @map.center_zoom_init([0,0], 2) 
	  end
	  @map.record_init('map.addControl(new TextualZoomControl()); map.addControl(new SearchControl());')
  end 

  def show
    @vessel = Vessel.find(params[:id])
    @vessel = YachtBot.find(@vessel.uscg_id) unless @vessel.builder
  end

end
