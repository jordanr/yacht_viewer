class Vessel < ActiveRecord::Base

  def description
    "#{name}"
  end

  def long_description
    "<div style='text-align: left'>
<b>#{name}</b><br/>
Length: #{length}<br/> 
Year: #{year}<br/> 
Service: #{service}<br/> 
USCG ID: #{uscg_id}<br/> 
Date: #{updated_at}
</div>
"
  end
end
