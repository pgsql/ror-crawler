# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110708215611) do

  create_table "configurations", :force => true do |t|
    t.text     "company_name"
    t.text     "ats"
    t.text     "duns"
    t.text     "map_frequency"
    t.text     "map_day_of_week"
    t.date     "date_created"
    t.date     "date_modified"
    t.date     "last_run"
    t.time     "time_of_last_run"
    t.integer  "no_of_times_run"
    t.boolean  "first_time"
    t.boolean  "has_next"
    t.text     "job_listing_option"
    t.boolean  "active"
    t.text     "save_path"
    t.text     "title"
    t.text     "url"
    t.text     "login"
    t.text     "password"
    t.text     "worker"
    t.boolean  "create_csv"
    t.boolean  "job_name"
    t.boolean  "working_time"
    t.boolean  "location"
    t.boolean  "organization_name"
    t.boolean  "department_creation"
    t.boolean  "brieff_description"
    t.boolean  "detailed_description"
    t.boolean  "job_requirments"
    t.boolean  "addition_details"
    t.boolean  "how_to_apply"
    t.boolean  "link"
    t.boolean  "save_html_blob"
    t.boolean  "save_html_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "csv_fields", :force => true do |t|
    t.string   "title"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.boolean  "active"
    t.string   "save_path"
    t.string   "title"
    t.string   "login"
    t.string   "worker"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "configuration_id"
    t.date     "date_created"
    t.date     "date_modified"
    t.boolean  "expired"
    t.text     "job_name"
    t.text     "working_title"
    t.text     "location"
    t.text     "organination_name"
    t.text     "brieff_description"
    t.text     "job_requirments"
    t.text     "additional_details"
    t.text     "how_to_apply"
    t.text     "link"
    t.binary   "html_blob"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
