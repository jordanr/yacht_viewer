class WelcomeController < ApplicationController
  def index
  end

  def about
    marker = GMarker.new(about_latlon, :title => about_description, :info_window =>about_long_description, :draggable=>true, :icon=>@icon)
    @map.declare_init(marker, "about_marker")
    @map.overlay_init(marker)
    @map.center_zoom_on_points_init(about_latlon)
    @map.record_init("GEvent.trigger(about_marker,'click');")
  end

  def random
    # build a bunch of random ids
    max = Vessel.count
    ids = []
    Vessel.per_page.times { |i| ids += [rand(max) + 1] }

    # get them
    @vessels = Vessel.paginate(ids, :page=>params[:page], :order => 'length DESC')
     
    post_map  

    render :template => 'welcome/search'
  end

  def search
    redirect_to :action=>:index and return if ! params[:query] or params[:query].empty?

    # search on multiple columns
    tokens = params[:query].split(" ")
    conds = make_conditions(tokens)
    @count = Vessel.count(:conditions=>conds)
    @vessels = Vessel.paginate(:all, :conditions=>conds, :page=>params[:page], :order=>'length DESC')

    post_map
  end 

  private
    def post_map
      markers = []

      # mark each vessel location that's showing
      @vessels.reverse_each do |vessel|
        # posibly populate
        latlon = vessel.latlon
        if latlon
          markers += [latlon]
          @map.overlay_init(GMarker.new(latlon, :title => description(vessel), :info_window =>long_description(vessel), :icon=> @icon))
        end
        # otherwise the location was bad, don't attempt to show it
      end

      # just show the markers tightly
      if markers != []
        @map.center_zoom_on_points_init(*markers)
      end
    end
end
