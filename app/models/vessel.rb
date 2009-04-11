require 'will_paginate'
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
end
