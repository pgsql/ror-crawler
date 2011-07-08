class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :configuration_id
      t.date :date_created
      t.date :date_modified
      t.boolean :expired
      t.text :job_name
      t.text :working_title
      t.text :location
      t.text :organination_name
      t.text :brieff_description
      t.text :job_requirments
      t.text :additional_details
      t.text :how_to_apply
      t.text :link
      t.binary :html_blob

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
