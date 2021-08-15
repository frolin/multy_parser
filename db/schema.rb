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

ActiveRecord::Schema.define(version: 2021_08_14_184055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "import_products", force: :cascade do |t|
    t.bigint "import_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["import_id"], name: "index_import_products_on_import_id"
    t.index ["product_id"], name: "index_import_products_on_product_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string "name"
    t.jsonb "data", default: {}
    t.string "importable_type", null: false
    t.bigint "importable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["importable_type", "importable_id"], name: "index_imports_on_importable"
  end

  create_table "options", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.jsonb "data"
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_options_on_product_id"
  end

  create_table "parsers", force: :cascade do |t|
    t.string "name"
    t.jsonb "settings", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "provider_id", null: false
    t.string "slug"
    t.index ["provider_id"], name: "index_parsers_on_provider_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sku"
    t.bigint "provider_id", null: false
    t.index ["provider_id"], name: "index_products_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
  end

  add_foreign_key "import_products", "imports"
  add_foreign_key "import_products", "products"
  add_foreign_key "options", "products"
  add_foreign_key "parsers", "providers"
  add_foreign_key "products", "providers"
end
