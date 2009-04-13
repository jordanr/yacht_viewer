class Sql
  attr_accessor :select, :from, :where, :group_by

  def self.operations
    [:like, :gt, :lt, :eq]
  end

  def self.eval(query)
    sql = ""
    qmarks = []
    
    sql = "SELECT * FROM vessels "
 
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
      sql += "TRUE" # fencepost
    end

    return [sql] + qmarks
  end
end
