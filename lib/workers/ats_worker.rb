#base lass for both ATS workers (TBNGo and BTNSearch)
#contains common methods
class ATSWorker < CSVMaker
  #saves simple HTML page with job details
  #decorates the page with <html><body> tags
  #those were sriped along with other jung
  def save_page(file_name, data, link)
    path = @job[:save_path]
    dirs = File.dirname(path)
    path = dirs+"/"+file_name+".html"
    data.gsub! /<img[^<]*>/, ""
    data = "<html>\n<body>\n<a href=\"#{link}\">#{file_name}</a>\n"+data+"\n</body>\n</html>"
    log "saving page to: "+File.expand_path(path)+"\n--------------\n"

    File.makedirs(dirs)
    f = File.new path, "w"
    cnt = f.write data
    f.close
  end

  #"next" link has different format of "onclick" attribute
  #this method converts it to format acceptable by method 'decorate_form'
  def prepare_next_link_options(next_link)
    onclick = next_link["onclick"]
    onclick.to_s =~/\(([^(]*)\)/
    opt = $1.split ","
    #next_link_opt = "{event :#{opt[1]}, source :#{opt[2]}, value :#{opt[4]}, size :#{opt[5]}, partialTargets :''}"
    next_link_opt = "{event :#{opt[1]}, source :#{opt[2]}, value :#{opt[4]}, size :#{opt[5]}, partialTargets :JobSearchTable}"
    #next_link_opt = "{event :#{opt[1]}, source :#{opt[2]}, value :#{opt[4]}, size :#{opt[5]}, partialTargets :#{opt[6]}}"
    next_link["onclick"] = next_link_opt
  end

  #replace different HTML enteties and tags to sybols which mean/look the same
  #but have nice look in CSV/Excel files
  def html2csv(data)
    dbg= data.gsub! "\n", ""
    dbg= data.gsub! "\xA0", " "
    dbg= data.gsub! "\r", ""
    dbg = data.gsub! /<br>/, "\n"
    dbg = data.gsub! /<\/p>/, "\n"
    dbg = data.gsub! /<\/div>/, "\n"
    dbg = data.gsub! /<ul[^>]*>/, "\n"
    dbg = data.gsub! /<li[^>]*>/, "\x95 "
    dbg = data.gsub! /<\/li>/, "\n"
    dbg = data.gsub! /<\/?\??\w+[^>]*>/, ""
    dbg = data.gsub! /[ ]{2,}/, " "
    dbg = data.gsub! /(\s?\n\s?){2,}/, "\n"
    dbg = data.strip!
    return data
  end

  #add fields from "onclick" event to form
  def decorate_form(form, onclick)

    fields = onclick.attr "onclick"
    fields.to_s =~ /\{([^}]+)\}/
    fields = $1
    fields = fields.split(",").map do |e|
      arr = e.gsub("'", "").split ":"
      arr.push "" unless arr.length == 2
      arr[0].strip!
      arr[1].strip!
      arr
    end
    fields.each do |field|
      form_field = form.field_with :name=>field[0]
      if form_field.nil?
        form.add_field! field[0]
        form_field = form.field_with :name=>field[0]
      end
      form_field.value= field[1]
    end
    return form
  rescue Exception => e
    puts e
  end
end