class CreateCsvFields < ActiveRecord::Migration
  def self.up
    create_table :csv_fields do |t|
      t.string :title
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :csv_fields
  end
end
