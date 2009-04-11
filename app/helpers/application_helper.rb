module ApplicationHelper

  # no results page
  def help
    "<div class='main'>
<p>  
Your search \"#{h params[:query]}\" did not match any vessels.
</p>

<p>
Try:
<ul>
<li>Checking your spelling</li>
<li>Fewer terms</li>
<li>More general terms</li>
</ul>
</p>
</div>"
  end


  # search over multiple columns
  def make_conditions(terms)
    sql = ""
    qmarks = []
    terms.each do |query|
      sql += "(LOWER(name) LIKE ? OR LOWER(location) LIKE ? OR LOWER(service) LIKE ? OR (length = ? AND length != 0) OR (year = ? AND year != 0)) AND "
      qmarks += ["%#{query}%", "%#{query}%", "%#{query}%", query, query]
    end

    sql += "TRUE"

    [sql] + qmarks
  end

  ########
  # About
  ########
  def about_latlon
    [26.057923, -80.133152]
  end

  def about_description
    "Yacht Map HQ"
  end

  def about_long_description
    "<div style='text-align: left'>
<b>Yacht Map</b><br/>
Email: richard@jordanyachts.com<br/>
Phone: (954) 296-2687<br/>
Street: 629 NE 3rd Street<br/>
City: Dania Beach<br/>
State: Florida<br/>
Zip: 33004
</div>
"
  end  


  #########
  # Vessel helpers
  ########

  def description(vessel)
    "#{vessel.name}"
  end

  def long_description(vessel)
    "<div style='text-align: left'>
<a href=\"#{vessel_path(vessel)}\"><i>#{vessel.name}</i></a><br/>
Length: #{vessel.length}<br/>
Year: #{vessel.year}<br/>
Service: #{vessel.service}<br/>
Location: #{location_count(vessel.location)}<br/>
USCG ID: #{vessel.uscg_id}<br/>
Date: #{vessel.updated_at}
</div>
"
  end

#############
# Filters
#########
  def pre_map
    @map = GMap.new("map_div")
    @map.set_map_type_init(GMapType::G_HYBRID_MAP)
    @map.center_zoom_init([0,0], 2)
    @map.record_init('map.addControl(new TextualZoomControl()); map.addControl(new SearchControl());')
  end

  private
    def location_count(location)
      num = Vessel.count(:conditions=>["location LIKE ?", "%#{location}%"])
      "<a href=\"#{search_path(:query=>location)}\" title=\"#{num} vessels\">#{location}</a>"
    end

end
