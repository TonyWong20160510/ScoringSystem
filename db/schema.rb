# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20160523014155) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.integer  "mobile"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "department_terms", :force => true do |t|
    t.string   "phase"
    t.string   "department_id"
    t.string   "integer"
    t.integer  "department_score"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "mobile",          :limit => 11
    t.integer  "department_id"
    t.string   "typename"
    t.string   "remember_token"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "marks", :force => true do |t|
    t.integer  "master_id"
    t.integer  "employee_id"
    t.integer  "department_id"
    t.string   "term_phase",       :limit => 30
    t.string   "master_score",     :limit => 4
    t.string   "department_score", :limit => 4
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "master_terms", :force => true do |t|
    t.string   "phase"
    t.integer  "master_id"
    t.integer  "master_score"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "masters", :force => true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
