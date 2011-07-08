class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.boolean :active
      t.string :save_path
      t.string :title
      t.string :login
      t.string :worker

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
