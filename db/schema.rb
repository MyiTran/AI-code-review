# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_15_093533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_models", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.boolean "is_default", default: false, null: false
    t.boolean "is_premium", default: false, null: false
    t.string "name", null: false
    t.string "provider", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_ai_models_on_slug", unique: true
  end

  create_table "github_installations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "account_login", null: false
    t.string "account_type", null: false
    t.datetime "created_at", null: false
    t.bigint "installation_id", null: false
    t.string "repository_selection", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["installation_id"], name: "index_github_installations_on_installation_id", unique: true
    t.index ["user_id"], name: "index_github_installations_on_user_id"
  end

  create_table "github_webhook_deliveries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.string "delivery_id", null: false
    t.string "event_name", null: false
    t.jsonb "payload", default: {}, null: false
    t.datetime "processed_at"
    t.string "status", default: "received", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_id"], name: "index_github_webhook_deliveries_on_delivery_id", unique: true
  end

  create_table "pull_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "author"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.bigint "github_id", null: false
    t.string "github_url"
    t.string "head_commit_sha"
    t.datetime "merged_at"
    t.integer "number", null: false
    t.datetime "opened_at"
    t.uuid "repository_id", null: false
    t.string "source_branch"
    t.string "state", null: false
    t.string "target_branch"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "github_id"], name: "index_pull_requests_on_repository_id_and_github_id", unique: true
    t.index ["repository_id", "number"], name: "index_pull_requests_on_repository_id_and_number", unique: true
    t.index ["repository_id"], name: "index_pull_requests_on_repository_id"
  end

  create_table "repositories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ai_model_id"
    t.boolean "auto_review_enabled", default: false, null: false
    t.boolean "connected", default: true, null: false
    t.datetime "connected_at", null: false
    t.datetime "created_at", null: false
    t.string "default_branch"
    t.text "description"
    t.datetime "disconnected_at"
    t.string "full_name", null: false
    t.bigint "github_id", null: false
    t.uuid "github_installation_id", null: false
    t.string "github_url"
    t.string "language"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "visibility"
    t.index ["ai_model_id"], name: "index_repositories_on_ai_model_id"
    t.index ["github_installation_id", "github_id"], name: "index_repositories_on_github_installation_id_and_github_id", unique: true
    t.index ["github_installation_id"], name: "index_repositories_on_github_installation_id"
  end

  create_table "reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ai_model_id", null: false
    t.string "base_commit_sha"
    t.datetime "commented_at"
    t.string "commit_sha", null: false
    t.datetime "created_at", null: false
    t.text "error_message"
    t.bigint "github_comment_id"
    t.integer "issues_found_count", default: 0, null: false
    t.integer "latency_ms"
    t.uuid "pull_request_id", null: false
    t.text "review_content"
    t.datetime "reviewed_at"
    t.string "status", default: "processing", null: false
    t.text "summary"
    t.integer "tokens_used"
    t.string "triggered_by"
    t.datetime "updated_at", null: false
    t.index ["ai_model_id"], name: "index_reviews_on_ai_model_id"
    t.index ["pull_request_id", "commit_sha", "ai_model_id"], name: "idx_on_pull_request_id_commit_sha_ai_model_id_b6a69c7c0b", unique: true
    t.index ["pull_request_id"], name: "index_reviews_on_pull_request_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.uuid "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.text "github_access_token"
    t.string "github_username"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "plan", default: "free", null: false
    t.integer "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "uid"
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_username"], name: "index_users_on_github_username"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, where: "((provider IS NOT NULL) AND (uid IS NOT NULL))"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.uuid "role_id"
    t.uuid "user_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "github_installations", "users"
  add_foreign_key "pull_requests", "repositories"
  add_foreign_key "repositories", "ai_models"
  add_foreign_key "repositories", "github_installations"
  add_foreign_key "reviews", "ai_models"
  add_foreign_key "reviews", "pull_requests"
end
