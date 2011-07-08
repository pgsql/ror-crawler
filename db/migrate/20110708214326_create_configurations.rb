class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.text :company_name
      t.text :ats
      t.text :duns
      t.text :map_frequency
      t.text :map_day_of_week
      t.date :date_created
      t.date :date_modified
      t.date :last_run
      t.time :time_of_last_run
      t.integer :no_of_times_run
      t.boolean :first_time
      t.boolean :has_next
      t.text :job_listing_option
      t.boolean :active
      t.text :save_path
      t.text :title
      t.text :url
      t.text :login
      t.text :password
      t.text :worker
      t.boolean :create_csv
      t.boolean :job_name
      t.boolean :working_time
      t.boolean :location
      t.boolean :organization_name
      t.boolean :department_creation
      t.boolean :brieff_description
      t.boolean :detailed_description
      t.boolean :job_requirments
      t.boolean :addition_details
      t.boolean :how_to_apply
      t.boolean :link
      t.boolean :save_html_blob
      t.boolean :save_html_file

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
