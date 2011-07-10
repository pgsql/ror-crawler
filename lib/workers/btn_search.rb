#Worker to scrap new ersion of Oracle Irecruiter
#All the commetnts are the same as BTNGo class
#the only difference is how next_form is obtained
class BTNSearch < ATSWorker
  def parse(page)
    super
    form = page.forms[0]
    options = page.parser.xpath '//*[@id="Search"]'
    decorate_form form, options
    form.field_with(:name =>"DatePosted2").options.last.select
    results = form.submit
    next_form_node = results.parser.xpath("//form").pop
    #here we save our own generated copy of form
    next_form = Mechanize::Form.new next_form_node, @agent
    pagenum =1
    parsed_count=0
    while true do
      log "Page: #{pagenum}"
      link_form = results.forms[0].clone
      joblinks = results.parser.css 'span#JobSearchTable table.x1h td.x1l a.xd'

      log "found #{joblinks.length} job links..."
      joblinks.each do |link|
        log "#{link.text}"
      end
      break if joblinks.length < 1
      joblinks.each do |joblink|
        decorate_form link_form, joblink
        datapage = link_form.submit

        csv_row = CSVRow.new(@fields)
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

#        csv_row.add "Job Name", job_name
#        csv_row.add "Working Title", working_title
#        csv_row.add "Location", location
#        csv_row.add "Organization Name", organization_name
#        csv_row.add "Department Description", department_description
#        csv_row.add "Brief Description", brief_description
#        csv_row.add "Detailed Description", detailed_description
#        csv_row.add "Job Requirements", job_requirements
#        csv_row.add "Additional Details", additional_details
#        csv_row.add "How To Apply", how_to_apply
#        csv_row.add "Link", link.to_s
#        "Department Description", department_description,
#        "Detailed Description", detailed_description,

        Result.create(:job_name => job_name, :working_title => working_title,:location  => location, :organination_name => organization_name,
        :organination_name => organization_name, :brieff_description => brief_description,
        :job_requirments => job_requirements,
        :additional_details => additional_details, :how_to_apply => how_to_apply,
      :link => link.to_s)

        @rows.push csv_row

        parsed_count +=1
        log "parsed #{job_name}"
        plain_data_to_be_saved = datapage.parser.xpath '//*[@id="Description"]'
        save_page job_name, plain_data_to_be_saved.to_html, link.to_s
        #break
      end
      #@data = to_csv
      #save_data
      log "saved #{parsed_count} items in total"
      next_link = results.parser.css 'span#JobSearchTable table tr td table.x1i tr td table tr td a.x41'
      break if next_link.nil? || (pagenum > 1 && next_link.length < 2)
      log "opening next page"
      next_link = next_link.pop
      prepare_next_link_options(next_link)

      decorate_form(next_form, next_link)
      #for some reason this fields gets changed
      #lets force it to empty value
      act = next_form.field_with(:name=>"IrcAction")
      act.value = ""
      results = next_form.submit
      pagenum +=1
    end
    log "Done!"
    #return to_csv
  end
end