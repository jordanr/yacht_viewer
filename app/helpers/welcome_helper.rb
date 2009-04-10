module WelcomeHelper
  def info_text(coord, num)
    "<div style='text-align: left'>
<b>#{num} vessels</b><br/>
Location: #{coord.address}<br/>
Latitude: #{coord.latitude}<br/>
Longitude: #{coord.longitude}<br/>
</div>"
  end

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


  def description(vessel)
    "#{vessel.name}"
  end

  def long_description(vessel)
    "<div style='text-align: left'>
<b>#{vessel.name}</b><br/>
Length: #{vessel.length}<br/>
Year: #{vessel.year}<br/>
Service: #{vessel.service}<br/>
Location: #{vessel.location} #{location_count(vessel.location)}<br/>
USCG ID: #{vessel.uscg_id}<br/>
Date: #{vessel.updated_at}
</div>
"
  end

  private
    def location_count(location)
      num = Vessel.count(:conditions=>["location LIKE ?", "%#{location}%"])
      "<a href=\"#{search_path(:query=>location)}\">#{num}</a>"
    end

end
