class CsvFieldsController < ApplicationController
  # GET /csv_fields
  # GET /csv_fields.xml
  def index
    @csv_fields = CsvField.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @csv_fields }
    end
  end

  # GET /csv_fields/1
  # GET /csv_fields/1.xml
  def show
    @csv_field = CsvField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @csv_field }
    end
  end

  # GET /csv_fields/new
  # GET /csv_fields/new.xml
  def new
    @csv_field = CsvField.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @csv_field }
    end
  end

  # GET /csv_fields/1/edit
  def edit
    @csv_field = CsvField.find(params[:id])
  end

  # POST /csv_fields
  # POST /csv_fields.xml
  def create
    @csv_field = CsvField.new(params[:csv_field])

    respond_to do |format|
      if @csv_field.save
        format.html { redirect_to(@csv_field, :notice => 'Csv field was successfully created.') }
        format.xml  { render :xml => @csv_field, :status => :created, :location => @csv_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @csv_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /csv_fields/1
  # PUT /csv_fields/1.xml
  def update
    @csv_field = CsvField.find(params[:id])

    respond_to do |format|
      if @csv_field.update_attributes(params[:csv_field])
        format.html { redirect_to(@csv_field, :notice => 'Csv field was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @csv_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /csv_fields/1
  # DELETE /csv_fields/1.xml
  def destroy
    @csv_field = CsvField.find(params[:id])
    @csv_field.destroy

    respond_to do |format|
      format.html { redirect_to(csv_fields_url) }
      format.xml  { head :ok }
    end
  end
end
