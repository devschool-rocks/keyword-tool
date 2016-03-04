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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160304154237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "tablefunc"

  create_table "domains", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_factors", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "h1"
    t.string   "html_text_ratio"
    t.integer  "ranking_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "page_factors", ["ranking_id"], name: "index_page_factors_on_ranking_id", using: :btree

  create_table "rankings", force: :cascade do |t|
    t.integer  "domain_id"
    t.integer  "keyword_id"
    t.string   "url"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rankings", ["domain_id"], name: "index_rankings_on_domain_id", using: :btree
  add_index "rankings", ["keyword_id"], name: "index_rankings_on_keyword_id", using: :btree

  create_table "serps_views", force: :cascade do |t|
  end

  add_foreign_key "page_factors", "rankings"
  add_foreign_key "rankings", "domains"
  add_foreign_key "rankings", "keywords"
end
