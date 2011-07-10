#Base class for all parsers
#Worker is someone who does the job
#jobs are described in ats.rb file

require 'rubygems'
require 'mechanize'
require 'mechanize/form'
require 'ftools'

class Worker

  #initializes a parser
  #loggs in if needed
  def initialize(job)
    @job = job
    @agent = Mechanize.new
    @agent.history.max_size=3

    @agent.open_timeout = 100000 #sometimes even this huge timeout is not enough...
    if job[:login] #job[:login] -- described in ats.rb
      url = job[:login][:url]
      log "Opening #{url} as a start/login page"
      begin
        login_page = @agent.get(url)
      rescue Exception => e #Sometimes we get 401, but exception brings datapage with it -- lets go parse it
        login_page = e.page
      end
      #do we need to fill the form?
      if job[:login][:form]
        form = job[:login][:form][:selector] ? login_page.form(job[:login][:form][:selector]) : login_page.forms.first
        form.field_with(:name => job[:login][:form][:username]).value = job[:login][:username]
        form.field_with(:name => job[:login][:form][:password]).value = job[:login][:password]
        add_fields_to_form form, job[:login][:form][:add_fields] if job[:login][:form][:add_fields]

        @page = form.submit

      end
      #so we have cookies here etc
      log "We're in" #maybe -- check for login error here!
    end
  rescue Exception => e
    log "Unable to login: #{e.message}"
  end

  #Adds fields to Mechanize::Form
  #mainly used for login forms
  def add_fields_to_form(form, fields)
    fields.each do |f|
      form.add_field!(f[:name], f[:value])
    end
  end

  #open base data page and perform parsing
  #calls parse method of its subclass
  def run
    log "Parsing..."
    if @job[:url]
      url = @job[:url]
      log "Opening #{url} as a data page"

      #get page according to URL what was setup in ats.rb
      @page = @agent.get(url)

      #parse method should be override in subclasses
      @data = parse(@page)
    else
      #some jobs do not have "datapage" URL
      #for example after login you're already on your very own datapage
      #this is to be addressed in 'parse' method of subclass
      @data = parse(nil)
    end

    #saves @data to where @job[:save_path] points
    #@data should be already a CSV string
    #only has meaning for CSV worker(s)
    save_data if @job[:save_path]

  rescue Exception=>e
    puts "Failed to parse URL '#{url}', exception=>"+e.message
  end

  #this must be overriden in subclasses
  #actually a subclass can call super()
  #to have this nice output to logs
  def parse(page)
    #the only thing this base method does -- outputs Job title
    job_title = @job[:title] ? @job[:title] : "!!! No name in config !!!"
    log "-------------- Job title: #{job_title} --------------"
    return "Parsing method not implemented in the worker!\nContact yuriy.horobey@gmail.com for support."
  end

  #saves @data to where @job[:save_to] points
  #@data should be already a CSV string
  def save_data
    path = @job[:save_path]
    log "--------------\nsaving to: "+File.expand_path(path)+"\n\n"
    dirs = File.dirname(path)
#    puts "*************** path.inspect ****************"
#    puts path.inspect
#    puts "*************** @data.inspect ****************"
#    puts @data.inspect
    #make absent dirs in the path
    File.makedirs(dirs)
    f = File.new path, "w"
    f.write @data
    f.close
  end

  #output to terminal screen
  #in future version can make some smart formatting etc
  def log(what)
    puts what
  end
end