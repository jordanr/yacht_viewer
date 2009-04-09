require 'vessel'
require 'uri'
require 'net/http'
#require 'regexp'

# Yacht Bot
#
# Hello, my name is Yacht Bot.  I like to
# crawl the U.S. Coast Guard's Documenation Search.
# I scrape vessel data from http://www.st.nmfs.noaa.gov/st1/CoastGuard/VesselByName.html
class YachtBot

  # the site and input search key
  USCG_DB = "http://www.st.nmfs.noaa.gov/pls/webpls/cgv_pkg.vessel_name_list"
  SEARCH_KEY = :vessel_name_in

  # repeated regex; no less than signs
  NO_LT = '([^<]*)'

  # tells the number of results
  RESULTS_NEEDLE = Regexp.escape('You asked for a vessel with a name like "') + '[^"]*' +
		Regexp.escape('". That selection resulted in') + '[^0-9]*([0-9,]+)[^0-9]*' + Regexp.escape('matches.')

  # tells if there was an error, i.e too many or 0 results
  ERROR_NEEDLE = 'Please re-do your selection criteria and try again.'

  # what to look for and how to scrape
  DATA_NEEDLE = Regexp.escape('<TR>
<TD ALIGN="RIGHT">') + '[^<]*' + Regexp.escape('</TD>
<TD><A HREF="/pls/webpls/cgv_pkg.vessel_id_list?vessel_id_in=') + '[0-9]+' + Regexp.escape('">') + NO_LT + Regexp.escape('</A></TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD>') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="CENTER">') + NO_LT + Regexp.escape('</TD>
<TD ALIGN="RIGHT">') + NO_LT + Regexp.escape('</TD>
</TR>')

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
      vessels = []
      this_created = 0

      puts
      puts "Searching for #{search_value}..."
      # get the html page
      body = get(search_value)

      num_vessels = results(body)
      # if the search had too many results
      if error?(body) and num_vessels > 0
        ('a'..'z').each { |letter| queue.push(search_value + letter) }

      elsif error?(body)
        # no results eh?
#        invisibles += [search_value] unless data(body).empty?  # mistake?
        
      else # log the results in the db
        vessels = data(body)
        
        # not showing them all; we'll keep searching this branch
        if vessels.size > 0 and num_vessels != vessels.size
          ('a'..'z').each { |letter| queue.push(search_value + letter) }
        # it's showing them but we can't see them
        else
          # do a different type of scrape
        end        
 
        this_created = create_unless_exists(vessels)
        found += vessels.size
        created += this_created
      end

      puts "found #{vessels.size.to_s}; created #{this_created.to_s} vessels"
      puts
    end

    puts "found #{found} total vessels; created #{created} total vessels"
 #   puts invisibles.join(", ") unless invisibles.empty?
    puts
  end

  # Was the query successfule (not too many not zero results)?
  def self.error?(body)
    /#{ERROR_NEEDLE}/.match(body)
  end

  # return the number of matching vessels
  def self.results(body)    
    results = /#{RESULTS_NEEDLE}/.match(body)
    return 0 unless results and results.size == 2
    results[1].gsub(",","").to_i
  end

  # scrape and return array of data quintuples
  def self.data(body)
    body.scan(/#{DATA_NEEDLE}/x)
  end
 

  private
    def self.get(search_value)
      # socket 
      first_time = true
      res = nil
      begin
        res = Net::HTTP.post_form(URI.parse(USCG_DB), SEARCH_KEY => search_value) if first_time
      rescue # socket error
        first_time = false
        sleep 1 # wait a second
        retry
      end
      res ? res.body : ""
    end
 
    # Create unless the uscg doc id is already in the db
    def self.create_unless_exists(vessels)
      # how many new vessels in db
      created = 0 

      # db check
      vessels.each do |v|
        puts v.inspect 
        if not Vessel.exists?(:uscg_id => v[5])
          Vessel.create({:name=>v[0], :year=>v[1], :service=>v[2], :location=>v[3], :length=>v[4], :uscg_id=>v[5]}) 
          created += 1 
        end
      end

      return created
    end
end

