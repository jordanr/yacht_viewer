require 'will_paginate'
require 'yacht_bot'
class Vessel < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  def to_s
    "#{name}: #{length} #{builder} #{year} #{owner_name}"
  end

  def owner_name
    owner ? owner.split('<br>').first : ""
  end

  # geocode address - populat if needed
  def latlon
    if latitude.nil? or longitude.nil?
      results = Geocoding::get(location, :key=>Ym4r::GmPlugin::ApiKey.get)
      if results.status == Geocoding::GEO_SUCCESS
        coord = results.first # assume the first is alright
        update_attributes(:address=>coord.address, :latitude=>coord.latitude, :longitude=>coord.longitude)
      else
	puts "Geocode failure: #{results.status}"
	return nil
      end
    end
    [latitude, longitude] 
  end

  # Maybe populates in from USCG if not already populated
  def self.find_and_populate(id)
    vessel = find(id)
    # populate?
    vessel.builder.nil? ? YachtBot.find(vessel.uscg_id) : vessel
  end


  def update_open_attributes(attrs) 
    attrs.delete_if { |k,v| ! open_attributes.include?(k.to_s) }
    update_attributes(attrs)
  end

  def update_semiopen_attributes(attrs)
    attrs.delete_if { |k,v| ! semiopen_attributes.include?(k.to_s) }
    update_attributes(attrs)
  end

  private
    def semiopen_attributes
      %w{ price broker } + open_attributes
    end
 
    def open_attributes
      %w{ make model address latitude longitude }
    end
end
