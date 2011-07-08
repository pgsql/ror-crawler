#base class for all parsers which deal with CSV
#this class most likely is to be owerrriden by subclasses found in "workers" folders
class CSVMaker < Worker

  #constructor 'login' is reserved for future use
  def initialize(job, login=nil)
    super job
    #CSV fields, used to generate CSV file header
    @fields = @job[:csv_fields]
    #array containing CSVRow objects, see below
    @rows = []
  end

  #convert array of CSVRow objects
  #into CSV strings separated by new line (\n) character
  def to_csv
    arr_rows =[]
    #get all the fields
    @rows.each do |row|
      row.flattern
      #collect field names from rows
      #we need this because there can be duplicated rows which we can't predict
      #like Pads or Batteries
      @fields |= row.fields
    end
    #Make a header row
    header = CSVRow.new @fields
    @fields.each do |f|
      header.set f, f
    end
    arr_rows.push header.to_csv

    #tell each row the combined fieldset
    #and convert it to CSV
    @rows.each do |row|
      row.fields @fields
      arr_rows.push row.to_csv
    end
    ret = arr_rows.join "\n"
    return ret
  end
end

#class to store CSV row
class CSVRow
  def initialize(fields)
    @fields = fields
    @row={}
  end

  #getter/setter
  def fields(arg=nil)
    if arg.is_a?(Array)
      @fields= arg
    end
    return @fields
  end

  #set/override field by <name>
  def set(name, val)
    val = "" unless val
    @row[name]=val
  end

  #set field by <name> as set() above or
  #convert existing value to array and new value to it
  #later this will be converted to new field like:
  # we had field "battery" and you've added another battery
  #1st this second value will be stored in the same field "battery"
  #(having converted its value from scalar to array)
  #then, in time of saving CSV this second (3rd, 4th etc) value will be moved to fields
  #battery 1, ..2, 3 etc
  def add(name, val)
    oldval = get name
    if oldval.is_a?(Array)
      oldval.push val
      set name, oldval
      return
    elsif oldval
      newval = []
      newval.push oldval
      newval.push val
      set name, newval
      return
    else
      set name, val
      return
    end
  end

  #return value of field with <name>
  def get(name)
    if (@row.has_key?(name))
      return @row[name]
    end

  end

  #return self as CSV string
  def to_csv
    flattern
    ret =[]
    @fields.each do |f|
      val = get f
      if val
        val = val.gsub /"/, "'"
        val = "\"#{val}\""
      else
        val = '""'
      end
      ret.push val
    end
    ret = ret.join ","
    return ret
  end

  #convert all "array fields" (see add()) to new fields numbering them starting with 1
  def flattern
    newfields = []
    newrow = {}
    @fields.each do |f|
      val = get f
      if val.is_a?(Array)
        for i in 0..(val.length-1)
          if i>0
            new_f = f+" "+i.to_s
          else
            new_f =f
          end
          newfields.push new_f
          newrow[new_f]=val[i]
        end
      else
        newfields.push f
        newrow[f]=val
      end
    end
    @fields = newfields
    @row=newrow
  end

  #take all values and return array of them
  #seems like this is not in use anymore
  def to_a
    ret =[]
    @fields.each do |f|
      ret.push @row[f]
    end
    return ret;
  end
end