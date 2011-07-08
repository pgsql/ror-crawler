#This is worker to do scraping job for older Oracle IRecruiter engine
require File.dirname(__FILE__) + '/ats_worker'
class BTNGo < ATSWorker

  def parse(page)
    #put a header to terminal window -- you can skip this
    super

    #search form
    form = page.forms[0]

    #find search button
    options = page.parser.xpath '//*[@id="Go"]'

    #add fields found in onclick attribute from the search button to the form
    #stupid Oracle every click on any link converts to entire form to be submit...
    decorate_form form, options

    #this will not work with newer version, however you can experiment
    #keep in mind:
    #1) this can be crypted like 180S#d54Ss
    #2) if not crypted -- server checks for valid value and returns error 500 should it not accept yours
    #form.field_with(:name =>"DatePosted2").value= "180"

    #the best way: choose the latest option in the DateSelect field -- crypted or not -- it will be acepted
    form.field_with(:name =>"DatePosted2").options.last.select

    #result now contain page with links to the job-posting
    results = form.submit

    #page number -- to be output to terminal window
    pagenum =1

    #count of parsed/saved job-postings
    parsed_count=0
    while true do #this will break on complex condition(s) below
      log "Page: #{pagenum}"
      link_form = results.forms[0].clone #clone is needed because of way Mechanize/Nokogiry handles forms
      next_form = results.forms[0].clone

      #array of job links on the page
      joblinks = results.parser.css 'span#JobSearchTable table.x1h td.x1l a.xd'

      #log jobs count
      log "found #{joblinks.length} job links..."

      #output joblist to terminal
      joblinks.each do |link|
        log "#{link.text}"
      end

      #break if we have opened a page, but it is empty
      break if joblinks.length < 1

      #go through the joblinks list
      joblinks.each do |joblink|

        #since oracle submits form for each link,
        #parse link, take it onclick attribute and add it to the form
        decorate_form link_form, joblink

        #get detailed page with job posting
        datapage = link_form.submit

        #Parse the page and put data to CSV row
        csv_row = CSVRow.new(@fields)

        #each variable below corresponds to CSV field
        #handy for debug purposes
        job_name = joblink.text
        working_title = html2csv datapage.parser.xpath('//*[@id="JobTitle"]').inner_html
        location = html2csv datapage.parser.xpath('//*[@id="DerivedLocale"]').inner_html
        organization_name = html2csv datapage.parser.xpath('//*[@id="IrcPostingOrgName"]').inner_html
        department_description = html2csv datapage.parser.xpath('/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[9]/td[3]').inner_html
        brief_description = html2csv datapage.parser.xpath('/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[13]/td[3]').inner_html
        detailed_description = html2csv datapage.parser.xpath('/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[17]/td[3]').inner_html
        job_requirements = html2csv datapage.parser.xpath('/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[21]/td[3]').inner_html
        additional_details = html2csv datapage.parser.xpath('/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[25]/td[3]').inner_html
        how_to_apply = html2csv datapage.parser.xpath('/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[29]/td[3]').inner_html
        link = datapage.uri

        #now put variables with data into CSV row
        csv_row.add "Job Name", job_name
        csv_row.add "Working Title", working_title
        csv_row.add "Location", location
        csv_row.add "Organization Name", organization_name
        csv_row.add "Department Description", department_description
        csv_row.add "Brief Description", brief_description
        csv_row.add "Detailed Description", detailed_description
        csv_row.add "Job Requirements", job_requirements
        csv_row.add "Additional Details", additional_details
        csv_row.add "How To Apply", how_to_apply
        csv_row.add "Link", link.to_s

        #and this row to rows array
        @rows.push csv_row
        parsed_count +=1
        log "parsed #{job_name}"

        #save detailed page as a plain HTML file
        #kicking out most of unnecessary formatting
        plain_data_to_be_saved = datapage.parser.xpath '//*[@id="Description"]'
        save_page job_name, plain_data_to_be_saved.to_html, link.to_s
        #break
      end

      #convert all scraped CSV rows to plain CSV text
      @data = to_csv
      save_data
      log "saved #{parsed_count} items in total"

      #open next page

      #attention! this is an array of prev/next links
      #it contains 1 element on first (next) and last (prev) pages
      #or no elements if there is one and only page with job links
      next_link = results.parser.css 'span#JobSearchTable table tr td table.x1i tr td table tr td a.x41'

      #check if just parsed the last page
      break if next_link.nil? || (pagenum > 1 && next_link.length < 2)
      log "opening next page"
      next_link = next_link.pop #if not last page we have 2 links with the same

      #same thing as before -- convert onclick attribute to form fields
      prepare_next_link_options(next_link)
      decorate_form(form, next_link)

      #open the next page
      results = form.submit
      pagenum +=1
      # break if pagenum > 5 #this is for debug -- disregard
    end

    log "Done!"
    return to_csv
  end

end
