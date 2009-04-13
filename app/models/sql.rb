class Sql
  attr_accessor :select, :from, :where, :group_by

  def self.operations
    [:like, :gt, :lt, :eq]
  end

  def self.eval(query)
    sql = ""
    qmarks = []

    query["select"] = ["*"] if not query["select"]
    select_terms = query["select"].is_a?(Array) ? query["select"] :  [query["select"]]

    if select_terms.all? { |term| (["*"] + Vessel.column_names).include?(term) }
      sql = "SELECT #{select_terms.join(',')} FROM vessels "
    else
      raise Exception("invalid select term")
    end

 
    if query["where"]
      sql += "WHERE "
      query["where"].each_pair do |key, term| 
        raise Exception("invalid where term") if ! Vessel.column_names.include?(term["column"])
	sql += term["column"]
        case term["operation"]
          when "like"
            sql += " LIKE ?"
          when "gt"
            sql += " > ?"
          when "lt"
            sql += " < ?"
          when "eq"
            sql += " = ?"
	  else
	    raise Exception("operation not supported")
	end
        qmarks += [term['value']]
        sql += " AND "
      end    
      sql += "TRUE " # fencepost
    end

    if query["group_by"]
      group_by_terms = query["group_by"].is_a?(Array) ? query["group_by"] : [query["group_by"]]
      if group_by_terms.all? { |term| (Vessel.column_names).include?(term) }
        sql += "GROUP BY #{group_by_terms.join(",")} "
      else
        raise Exception("invalid group by term")
      end
    end
   
    sql += "LIMIT 50"  

    Vessel.find_by_sql([sql] + qmarks)
  end
end
