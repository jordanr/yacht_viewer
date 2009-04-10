require 'vessel'
require 'uri'
require 'net/http'

# Yacht Bot
#
# Hello, my name is Yacht Bot.  I like to
# crawl the U.S. Coast Guard's Documenation Search.
# I scrape vessel data from http://www.st.nmfs.noaa.gov/st1/CoastGuard/VesselByName.html
# and http://www.st.nmfs.noaa.gov/st1/CoastGuard/VesselByID.html
class YachtBot

  ####################
  # Constants
  ####################

  # the site and input search key
  NAME_DB = "http://www.st.nmfs.noaa.gov/pls/webpls/cgv_pkg.vessel_name_list"
  NAME_KEY = :vessel_name_in
  ID_DB = "http://www.st.nmfs.noaa.gov/pls/webpls/cgv_pkg.vessel_id_list"
  ID_KEY = :vessel_id_in

  # repeated regex; no less than signs
  NO_LT = '([^<]*)'
  BR_OR_NO_LT = '(.*)'

  # tells the number of results
  NAME_RESULTS_NEEDLE = Regexp.escape('You asked for a vessel with a name like "') + '[^"]*' +
		Regexp.escape('". That selection resulted in') + '[^0-9]*([0-9,]+)[^0-9]*' + Regexp.escape('matches.')

  # tells if there was an error, i.e too many or 0 results
  NAME_ERROR_NEEDLE = 'Please re-do your selection criteria and try again.'

  # what to look for and how to scrape
  NAME_DATA_NEEDLE = Regexp.escape('<TR>
<TD ALIGN="RIGHT">') + '[^<]*' + Regexp.escape('</TD>
<TD><A HREF="/pls/webpls/cgv_pkg.vessel_id_list?vessel_id_in=') + '[0-9]+' + Regexp.escape('">') + NO_LT + Regexp.escape('</A></TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="CENTER">') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">') + NO_LT + Regexp.escape('</TD>
</TR>')


  ID_DATA_NEEDLE = Regexp.escape('<TABLE  rules="all" border="1" class="results" width="100%">
<CAPTION><b>Data found in current database.</b></CAPTION>
<TR>
<TD ALIGN="RIGHT" width="24%">Vessel Name:</TD>
<TD width="24%"><B>') + NO_LT + Regexp.escape('</B></TD>
<TD ROWSPAN="11" class="gray" width="1%">&nbsp</TD>
<TD ALIGN="RIGHT" width="24%">USCG Doc. No.:</TD>
<TD width="24%"><B>') + NO_LT + Regexp.escape('</B></TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Vessel Service:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">IMO Number:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Trade Indicator:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">Call Sign:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Hull Material:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">Hull Number:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Ship Builder:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">Year Built:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT"> </TD>
<TD><br>
</TD>
<TD ALIGN="RIGHT">Length (ft.):</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Hailing Port:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">Hull Depth (ft.):</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT" ROWSPAN="3">Owner:</TD>
<TD ROWSPAN="3">') + BR_OR_NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">Hull Breadth (ft.):</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Gross Tonnage:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Net Tonnage:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
<TD ALIGN="RIGHT">Documentation Issuance Date:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">Documentation Expiration Date:</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
</TR>
<TR>
</TR>
<TR>
<TD><B>Previous Vessel Names:</B></TD>
<td>
') + BR_OR_NO_LT + Regexp.escape('
</td>
<TD class="gray">&nbsp</TD>
<TD><B>Previous Vessel Owners:</B></TD>
<td>
') + BR_OR_NO_LT + Regexp.escape('
</td>
</TR>
</TABLE>')


  ####################
  # Main Interface
  ####################

  # Now, I will start getting data.  This may take a long, long
  # time.  Hopefully, I'll get smarter and do it quicker someday.
  def self.crawl(queue=nil)
    # totals
    found = 0
    created = 0

    # Breadth First Search
    queue = ('a'..'z').to_a if ! queue

    # values 
    queue.each do |search_value|
      # tmp values
      dvessels = []
      this_created = 0

      puts
      puts "Searching for #{search_value}..."
      # get the html page
      body = get(NAME_DB, NAME_KEY, search_value)

      num_vessels = results(body)
      # if the search had too many results
      if error?(body) and num_vessels > 0
        ('a'..'z').each { |letter| queue.push(search_value + letter) }

      elsif error?(body)
        # no results eh?
#        invisibles += [search_value] unless vessels(body).empty?  # mistake?
        
      else # log the results in the db
        dvessels = vessels(body)
        
        # not showing them all; we'll keep searching this branch
        if dvessels.size > 0 and num_vessels != dvessels.size
          ('a'..'z').each { |letter| queue.push(search_value + letter) }
        # it's showing them but we can't see them
        else
          # do a different type of scrape
        end        
 
        this_created = create_unless_exists(dvessels)
        found += dvessels.size
        created += this_created
      end

      puts "found #{dvessels.size.to_s}; created #{this_created.to_s} vessels"
      puts
    end

    puts "found #{found} total vessels; created #{created} total vessels"
 #   puts invisibles.join(", ") unless invisibles.empty?
    puts
  end

  def self.find(uscg_id)
      body = get(ID_DB, ID_KEY, uscg_id)
      dinfo = info(body)
      if dinfo and dinfo.size == 1
        create_or_update(dinfo.first)
      else
        puts "Error finding #{uscg_id}: #{dinfo.inspect}"
	nil
      end
  end


  ####################
  # Public Helpers
  ####################

  def self.info(body)
    data(body, ID_DATA_NEEDLE)
  end


  # Was the query successfule (not too many not zero results)?
  def self.error?(body)
    /#{NAME_ERROR_NEEDLE}/.match(body)
  end

  # return the number of matching vessels
  def self.results(body)    
    results = /#{NAME_RESULTS_NEEDLE}/.match(body)
    return 0 unless results and results.size == 2
    results[1].gsub(",","").to_i
  end

  def self.vessels(body)
    data(body, NAME_DATA_NEEDLE) 
  end

  #################
  # Private Helpers
  ##################

  private
    # scrape and return array of data tuples
    def self.data(body, needle)
      body.scan(/#{needle}/xm)
    end

    def self.get(db, search_key, search_value)
      # socket 
      first_time = true
      res = nil
      begin
        res = Net::HTTP.post_form(URI.parse(db), search_key => search_value) if first_time
      rescue # socket error
        first_time = false
        sleep 1 # wait a second
        retry
      end
      res ? res.body : ""
    end
 
    # Create unless the uscg doc id is already in the db
    def self.create_unless_exists(dvessels)
      # how many new vessels in db
      created = 0 

      # db check
      dvessels.each do |v|
        puts v.inspect 
        if not Vessel.exists?(:uscg_id => v[5])
          Vessel.create({:name=>v[0], :year=>v[1], :service=>v[2], :location=>v[3], :length=>v[4], :uscg_id=>v[5]}) 
          created += 1 
        end
      end

      return created
    end

    def self.create_or_update(dinfo)
      ivessel = { :name => dinfo[0], :uscg_id=>dinfo[1], :service=>dinfo[2], :imo_number=>dinfo[3],
	:trade_indicator => dinfo[4], :call_sign=>dinfo[5], :hull_material=>dinfo[6],
	:hull_number=>dinfo[7], :builder=>dinfo[8], :year=>dinfo[9], :length=>dinfo[10],
	:location => dinfo[11], :hull_depth=>dinfo[12], :owner=>dinfo[13], :hull_breadth=>dinfo[14],
	:gross_tonnage=> dinfo[15], :net_tonnage=>dinfo[16], :issuance_date=>dinfo[17], :expiration_date=>dinfo[18],
	:previous_names=>dinfo[19], :previous_owners=>dinfo[20], :address=>nil, :latitude=>nil, :longitude=>nil
      }
      if Vessel.exists?(:uscg_id=>dinfo[1])
        dvessel = Vessel.find_by_uscg_id(dinfo[1])
        dvessel.update_attributes(ivessel)
	puts "updated"
      else
        dvessel = Vessel.create(ivessel)
	puts "created"
      end
      dvessel
    end
 
end

