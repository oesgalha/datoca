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

ActiveRecord::Schema.define(version: 20161004012756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acceptances", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["competition_id"], name: "index_acceptances_on_competition_id", using: :btree
    t.index ["user_id"], name: "index_acceptances_on_user_id", using: :btree
  end

  create_table "ar_internal_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "file_id"
    t.string   "file_filename"
    t.string   "file_content_type"
    t.integer  "file_size"
    t.integer  "instruction_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["instruction_id"], name: "index_attachments_on_instruction_id", using: :btree
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_team_size"
    t.integer  "evaluation_type",                                   default: 0
    t.decimal  "total_prize",               precision: 9, scale: 2
    t.datetime "deadline"
    t.string   "ilustration_id"
    t.string   "ilustration_filename"
    t.string   "ilustration_content_type"
    t.integer  "ilustration_size"
    t.string   "expected_csv_id"
    t.string   "expected_csv_filename"
    t.string   "expected_csv_content_type"
    t.integer  "expected_csv_size"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  create_table "instructions", force: :cascade do |t|
    t.string   "name"
    t.text     "markdown"
    t.text     "html"
    t.integer  "competition_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["competition_id"], name: "index_instructions_on_competition_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.text     "explanation_md"
    t.text     "explanation_html"
    t.string   "csv_id"
    t.string   "csv_filename"
    t.string   "csv_content_type"
    t.integer  "csv_size"
    t.integer  "competition_id"
    t.string   "competitor_type"
    t.integer  "competitor_id"
    t.decimal  "evaluation_score", precision: 20, scale: 10
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["competition_id"], name: "index_submissions_on_competition_id", using: :btree
    t.index ["competitor_type", "competitor_id"], name: "index_submissions_on_competitor_type_and_competitor_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "avatar_id"
    t.string   "avatar_filename"
    t.string   "avatar_content_type"
    t.integer  "avatar_size"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.index ["team_id"], name: "index_teams_users_on_team_id", using: :btree
    t.index ["user_id"], name: "index_teams_users_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "handle"
    t.text     "bio"
    t.string   "location"
    t.string   "company"
    t.string   "avatar_id"
    t.string   "avatar_filename"
    t.string   "avatar_content_type"
    t.integer  "avatar_size"
    t.integer  "role",                   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "acceptances", "competitions"
  add_foreign_key "acceptances", "users"
  add_foreign_key "attachments", "instructions"
  add_foreign_key "instructions", "competitions"
  add_foreign_key "submissions", "competitions"

  create_view :rankings, materialized: true,  sql_definition: <<-SQL
      WITH top_submissions AS (
           SELECT per_competitor.submission_id,
              per_competitor.competitor_id,
              per_competitor.competitor_type,
              per_competitor.evaluation_score,
              per_competitor.competition_id,
              per_competitor.competitor_rank
             FROM ( SELECT submissions.id AS submission_id,
                      submissions.competitor_id,
                      submissions.competitor_type,
                      submissions.evaluation_score,
                      submissions.competition_id,
                      rank() OVER (PARTITION BY submissions.competition_id, submissions.competitor_id, submissions.competitor_type ORDER BY submissions.evaluation_score) AS competitor_rank
                     FROM submissions) per_competitor
            WHERE (per_competitor.competitor_rank = 1)
          )
   SELECT top_submissions.submission_id,
      top_submissions.competitor_id,
      top_submissions.competitor_type,
      top_submissions.evaluation_score,
      top_submissions.competition_id,
      rank() OVER (PARTITION BY top_submissions.competition_id ORDER BY top_submissions.evaluation_score) AS rank
     FROM top_submissions;
  SQL

end
