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

ActiveRecord::Schema.define(version: 0) do

  create_table "lovd_active_columns", primary_key: "colid", id: :string, limit: 100, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "created_by",   limit: 2
    t.datetime "created_date",           null: false
    t.index ["created_by"], name: "created_by", using: :btree
  end

  create_table "lovd_alleles", id: :integer, limit: 1, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",          limit: 20, null: false
    t.boolean "display_order",            null: false, unsigned: true
  end

  create_table "lovd_announcements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type",           limit: 15,    default: "information",         null: false
    t.text     "announcement",   limit: 65535,                                 null: false
    t.datetime "start_date",                                                   null: false
    t.datetime "end_date",                     default: '9999-12-31 23:59:59', null: false
    t.boolean  "lovd_read_only",               default: false,                 null: false
    t.integer  "created_by",     limit: 2
    t.datetime "created_date",                                                 null: false
    t.integer  "edited_by",      limit: 2
    t.datetime "edited_date"
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
  end

  create_table "lovd_chromosomes", primary_key: "name", id: :string, limit: 2, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "sort_id",      limit: 1,  null: false, unsigned: true
    t.string  "hg18_id_ncbi", limit: 20, null: false
    t.string  "hg19_id_ncbi", limit: 20, null: false
  end

  create_table "lovd_colleagues", primary_key: ["userid_from", "userid_to"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "userid_from", limit: 2,                 null: false
    t.integer "userid_to",   limit: 2,                 null: false
    t.boolean "allow_edit",            default: false, null: false
    t.index ["userid_to"], name: "userid_to", using: :btree
  end

  create_table "lovd_columns", id: :string, limit: 100, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "col_order",                limit: 1,     null: false, unsigned: true
    t.integer  "width",                    limit: 2,     null: false, unsigned: true
    t.boolean  "hgvs",                                   null: false
    t.boolean  "standard",                               null: false
    t.boolean  "mandatory",                              null: false
    t.string   "head_column",              limit: 50,    null: false
    t.text     "description_form",         limit: 65535, null: false
    t.text     "description_legend_short", limit: 65535, null: false
    t.text     "description_legend_full",  limit: 65535, null: false
    t.string   "mysql_type",                             null: false
    t.text     "form_type",                limit: 65535, null: false
    t.text     "select_options",           limit: 65535, null: false
    t.string   "preg_pattern",                           null: false
    t.boolean  "public_view",                            null: false
    t.boolean  "public_add",                             null: false
    t.boolean  "allow_count_all",                        null: false
    t.integer  "created_by",               limit: 2
    t.datetime "created_date",                           null: false
    t.integer  "edited_by",                limit: 2
    t.datetime "edited_date"
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
  end

  create_table "lovd_columns2links", primary_key: ["colid", "linkid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "colid",  limit: 100, null: false
    t.integer "linkid", limit: 1,   null: false
    t.index ["linkid"], name: "linkid", using: :btree
  end

  create_table "lovd_config", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "system_title",                                                                       null: false
    t.string  "institute",                                                                          null: false
    t.string  "location_url",                                                                       null: false
    t.string  "email_address",                limit: 75,                                            null: false
    t.boolean "send_admin_submissions",                                                             null: false
    t.integer "api_feed_history",             limit: 1,                                             null: false, unsigned: true
    t.string  "refseq_build",                 limit: 4,                                             null: false
    t.string  "proxy_host",                                                                         null: false
    t.integer "proxy_port",                   limit: 2,                                                          unsigned: true
    t.string  "proxy_username",                                                                     null: false
    t.string  "proxy_password",                                                                     null: false
    t.string  "logo_uri",                     limit: 100, default: "gfx/LOVD3_logo145x50.jpg",      null: false
    t.string  "mutalyzer_soap_url",           limit: 100, default: "https://mutalyzer.nl/services", null: false
    t.string  "omim_apikey",                  limit: 40,                                            null: false
    t.boolean "send_stats",                                                                         null: false
    t.boolean "include_in_listing",                                                                 null: false
    t.boolean "allow_submitter_registration",             default: true,                            null: false
    t.boolean "lock_users",                                                                         null: false
    t.boolean "allow_unlock_accounts",                                                              null: false
    t.boolean "allow_submitter_mods",                                                               null: false
    t.boolean "allow_count_hidden_entries",                                                         null: false
    t.boolean "use_ssl",                                                                            null: false
    t.boolean "use_versioning",                                                                     null: false
    t.boolean "lock_uninstall",                                                                     null: false
  end

  create_table "lovd_countries", id: :string, limit: 2, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
  end

  create_table "lovd_data_status", id: :boolean, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 15, null: false
  end

  create_table "lovd_diseases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "symbol",       limit: 25,    null: false
    t.string   "name",                       null: false
    t.integer  "id_omim",                                 unsigned: true
    t.text     "tissues",      limit: 65535, null: false
    t.text     "features",     limit: 65535, null: false
    t.text     "remarks",      limit: 65535, null: false
    t.integer  "created_by",   limit: 2
    t.datetime "created_date",               null: false
    t.integer  "edited_by",    limit: 2
    t.datetime "edited_date"
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["id_omim"], name: "id_omim", unique: true, using: :btree
  end

  create_table "lovd_external_sources", id: :string, limit: 15, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "url", null: false
  end

  create_table "lovd_genes", id: :string, limit: 25, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                               null: false
    t.string   "chromosome",       limit: 2
    t.string   "chrom_band",       limit: 20,                        null: false
    t.string   "imprinting",       limit: 10,    default: "unknown", null: false
    t.string   "refseq_genomic",   limit: 15,                        null: false
    t.string   "refseq_UD",        limit: 25,                        null: false
    t.string   "reference",                                          null: false
    t.string   "url_homepage",                                       null: false
    t.text     "url_external",     limit: 65535,                     null: false
    t.boolean  "allow_download",                                     null: false
    t.boolean  "allow_index_wiki",                                   null: false
    t.integer  "id_hgnc",                                            null: false, unsigned: true
    t.integer  "id_entrez",                                                       unsigned: true
    t.integer  "id_omim",                                                         unsigned: true
    t.boolean  "show_hgmd",                                          null: false
    t.boolean  "show_genecards",                                     null: false
    t.boolean  "show_genetests",                                     null: false
    t.text     "note_index",       limit: 65535,                     null: false
    t.text     "note_listing",     limit: 65535,                     null: false
    t.string   "refseq",           limit: 1,                         null: false
    t.string   "refseq_url",                                         null: false
    t.boolean  "disclaimer",                                         null: false, unsigned: true
    t.text     "disclaimer_text",  limit: 65535,                     null: false
    t.text     "header",           limit: 65535,                     null: false
    t.boolean  "header_align",                                       null: false
    t.text     "footer",           limit: 65535,                     null: false
    t.boolean  "footer_align",                                       null: false
    t.integer  "created_by",       limit: 2
    t.datetime "created_date",                                       null: false
    t.integer  "edited_by",        limit: 2
    t.datetime "edited_date"
    t.integer  "updated_by",       limit: 2
    t.datetime "updated_date"
    t.index ["chromosome"], name: "chromosome", using: :btree
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["id_hgnc"], name: "id_hgnc", unique: true, using: :btree
    t.index ["updated_by"], name: "updated_by", using: :btree
  end

  create_table "lovd_genes2diseases", primary_key: ["geneid", "diseaseid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "geneid",    limit: 25, null: false
    t.integer "diseaseid", limit: 2,  null: false
    t.index ["diseaseid"], name: "diseaseid", using: :btree
  end

  create_table "lovd_individuals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "fatherid",                      limit: 3
    t.integer  "motherid",                      limit: 3
    t.integer  "panelid",                       limit: 3
    t.integer  "panel_size",                    limit: 3,     default: 1, null: false, unsigned: true
    t.integer  "owned_by",                      limit: 2
    t.boolean  "statusid",                                                             unsigned: true
    t.integer  "created_by",                    limit: 2
    t.datetime "created_date",                                            null: false
    t.integer  "edited_by",                     limit: 2
    t.datetime "edited_date"
    t.string   "Individual/Lab_ID",             limit: 15
    t.string   "Individual/Reference",          limit: 200
    t.text     "Individual/Remarks",            limit: 65535
    t.text     "Individual/Remarks_Non_Public", limit: 65535
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["fatherid"], name: "fatherid", using: :btree
    t.index ["motherid"], name: "motherid", using: :btree
    t.index ["owned_by"], name: "owned_by", using: :btree
    t.index ["panelid"], name: "lovd_individuals_fk_panelid", using: :btree
    t.index ["statusid"], name: "statusid", using: :btree
  end

  create_table "lovd_individuals2diseases", primary_key: ["individualid", "diseaseid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "individualid", limit: 3, null: false
    t.integer "diseaseid",    limit: 2, null: false
    t.index ["diseaseid"], name: "diseaseid", using: :btree
  end

  create_table "lovd_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",         limit: 50,    null: false
    t.string   "pattern_text", limit: 25,    null: false
    t.text     "replace_text", limit: 65535, null: false
    t.text     "description",  limit: 65535, null: false
    t.integer  "created_by",   limit: 2
    t.datetime "created_date",               null: false
    t.integer  "edited_by",    limit: 2
    t.datetime "edited_date"
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["name"], name: "name", unique: true, using: :btree
    t.index ["pattern_text"], name: "pattern_text", unique: true, using: :btree
  end

  create_table "lovd_logs", primary_key: ["name", "date", "mtime"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",   limit: 10,    null: false
    t.datetime "date",                 null: false
    t.integer  "mtime",  limit: 3,     null: false
    t.integer  "userid", limit: 2
    t.string   "event",  limit: 20,    null: false
    t.text     "log",    limit: 65535, null: false
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "lovd_modules", id: :string, limit: 15, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",           limit: 50,    null: false
    t.string  "version",        limit: 15,    null: false
    t.string  "description",                  null: false
    t.boolean "active",                       null: false
    t.text    "settings",       limit: 65535, null: false
    t.date    "installed_date",               null: false
    t.date    "updated_date"
  end

  create_table "lovd_phenotypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "diseaseid",             limit: 2,     null: false
    t.integer  "individualid",          limit: 3,     null: false
    t.integer  "owned_by",              limit: 2
    t.boolean  "statusid",                                         unsigned: true
    t.integer  "created_by",            limit: 2
    t.datetime "created_date",                        null: false
    t.integer  "edited_by",             limit: 2
    t.datetime "edited_date"
    t.text     "Phenotype/Additional",  limit: 65535
    t.string   "Phenotype/Inheritance", limit: 50
    t.string   "Phenotype/Age",         limit: 12
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["diseaseid"], name: "diseaseid", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["individualid"], name: "individualid", using: :btree
    t.index ["owned_by"], name: "owned_by", using: :btree
    t.index ["statusid"], name: "statusid", using: :btree
  end

  create_table "lovd_screenings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "individualid",        limit: 3,                    null: false
    t.boolean  "variants_found",                    default: true, null: false
    t.integer  "owned_by",            limit: 2
    t.integer  "created_by",          limit: 2
    t.datetime "created_date",                                     null: false
    t.integer  "edited_by",           limit: 2
    t.datetime "edited_date"
    t.text     "Screening/Technique", limit: 65535
    t.text     "Screening/Template",  limit: 65535
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["individualid"], name: "individualid", using: :btree
    t.index ["owned_by"], name: "owned_by", using: :btree
  end

  create_table "lovd_screenings2genes", primary_key: ["screeningid", "geneid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "screeningid",            null: false
    t.string  "geneid",      limit: 25, null: false
    t.index ["geneid"], name: "geneid", using: :btree
    t.index ["screeningid"], name: "screeningid", using: :btree
  end

  create_table "lovd_screenings2variants", primary_key: ["screeningid", "variantid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "screeningid", null: false
    t.integer "variantid",   null: false
    t.index ["screeningid"], name: "screeningid", using: :btree
    t.index ["variantid"], name: "variantid", using: :btree
  end

  create_table "lovd_shared_columns", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "geneid",                   limit: 25
    t.integer  "diseaseid",                limit: 2
    t.string   "colid",                    limit: 100,   null: false
    t.integer  "col_order",                limit: 1,     null: false, unsigned: true
    t.integer  "width",                    limit: 2,     null: false, unsigned: true
    t.boolean  "mandatory",                              null: false
    t.text     "description_form",         limit: 65535, null: false
    t.text     "description_legend_short", limit: 65535, null: false
    t.text     "description_legend_full",  limit: 65535, null: false
    t.text     "select_options",           limit: 65535, null: false
    t.boolean  "public_view",                            null: false
    t.boolean  "public_add",                             null: false
    t.integer  "created_by",               limit: 2
    t.datetime "created_date",                           null: false
    t.integer  "edited_by",                limit: 2
    t.datetime "edited_date"
    t.index ["colid"], name: "colid", using: :btree
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["diseaseid", "colid"], name: "diseaseid", unique: true, using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["geneid", "colid"], name: "geneid", unique: true, using: :btree
  end

  create_table "lovd_status", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "lock_update",                        null: false
    t.string   "version",              limit: 15,    null: false
    t.string   "signature",            limit: 32,    null: false
    t.datetime "update_checked_date"
    t.string   "update_version",       limit: 15
    t.boolean  "update_level",                                    unsigned: true
    t.text     "update_description",   limit: 65535
    t.date     "update_released_date"
    t.date     "installed_date",                     null: false
    t.date     "updated_date"
  end

  create_table "lovd_transcripts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "geneid",                limit: 25,    null: false
    t.string   "name",                                null: false
    t.integer  "id_mutalyzer",          limit: 1
    t.string   "id_ncbi",                             null: false
    t.string   "id_ensembl",                          null: false
    t.string   "id_protein_ncbi",                     null: false
    t.string   "id_protein_ensembl",                  null: false
    t.string   "id_protein_uniprot",    limit: 8,     null: false
    t.text     "remarks",               limit: 65535, null: false
    t.integer  "position_c_mrna_start", limit: 2,     null: false
    t.integer  "position_c_mrna_end",   limit: 3,     null: false, unsigned: true
    t.integer  "position_c_cds_end",    limit: 3,     null: false, unsigned: true
    t.integer  "position_g_mrna_start",               null: false, unsigned: true
    t.integer  "position_g_mrna_end",                 null: false, unsigned: true
    t.integer  "created_by",            limit: 2
    t.datetime "created_date",                        null: false
    t.integer  "edited_by",             limit: 2
    t.datetime "edited_date"
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["geneid"], name: "geneid", using: :btree
    t.index ["id_ncbi"], name: "id_ncbi", unique: true, using: :btree
  end

  create_table "lovd_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "orcid_id",              limit: 19
    t.boolean  "orcid_confirmed",                     default: false, null: false
    t.string   "name",                  limit: 75,                    null: false
    t.string   "institute",                                           null: false
    t.string   "department",                                          null: false
    t.string   "telephone",             limit: 50,                    null: false
    t.text     "address",               limit: 65535,                 null: false
    t.string   "city",                                                null: false
    t.string   "countryid",             limit: 2
    t.text     "email",                 limit: 65535,                 null: false
    t.boolean  "email_confirmed",                     default: false, null: false
    t.string   "reference",             limit: 50,                    null: false
    t.string   "username",              limit: 20,                    null: false
    t.string   "password",              limit: 50,                    null: false
    t.string   "password_autogen",      limit: 50
    t.boolean  "password_force_change",                               null: false
    t.string   "phpsessid",             limit: 32
    t.text     "saved_work",            limit: 65535
    t.boolean  "level",                                               null: false, unsigned: true
    t.string   "allowed_ip",                                          null: false
    t.boolean  "login_attempts",                                      null: false, unsigned: true
    t.datetime "last_login"
    t.integer  "created_by",            limit: 2
    t.datetime "created_date",                                        null: false
    t.integer  "edited_by",             limit: 2
    t.datetime "edited_date"
    t.index ["countryid"], name: "countryid", using: :btree
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["orcid_id"], name: "orcid_id", unique: true, using: :btree
    t.index ["username"], name: "username", unique: true, using: :btree
  end

  create_table "lovd_users2genes", primary_key: ["userid", "geneid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "userid",     limit: 2,              null: false
    t.string  "geneid",     limit: 25,             null: false
    t.boolean "allow_edit",                        null: false
    t.integer "show_order", limit: 1,  default: 1, null: false, unsigned: true
    t.index ["geneid"], name: "geneid", using: :btree
  end

  create_table "lovd_variant_effect", id: :integer, limit: 1, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 5, null: false
  end

  create_table "lovd_variants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "allele",                    limit: 1,               null: false, unsigned: true
    t.integer  "effectid",                  limit: 1
    t.string   "chromosome",                limit: 2
    t.integer  "position_g_start",                                               unsigned: true
    t.integer  "position_g_end",                                                 unsigned: true
    t.string   "type",                      limit: 10
    t.integer  "mapping_flags",             limit: 1,   default: 0, null: false, unsigned: true
    t.float    "average_frequency",         limit: 24,                           unsigned: true
    t.integer  "owned_by",                  limit: 2
    t.boolean  "statusid",                                                       unsigned: true
    t.integer  "created_by",                limit: 2
    t.datetime "created_date",                                      null: false
    t.integer  "edited_by",                 limit: 2
    t.datetime "edited_date"
    t.string   "VariantOnGenome/DBID",      limit: 50
    t.string   "VariantOnGenome/DNA",       limit: 100
    t.string   "VariantOnGenome/Frequency", limit: 15
    t.string   "VariantOnGenome/Reference"
    t.index ["allele"], name: "allele", using: :btree
    t.index ["average_frequency"], name: "average_frequency", using: :btree
    t.index ["chromosome", "position_g_start", "position_g_end"], name: "chromosome", using: :btree
    t.index ["created_by"], name: "created_by", using: :btree
    t.index ["edited_by"], name: "edited_by", using: :btree
    t.index ["effectid"], name: "effectid", using: :btree
    t.index ["owned_by"], name: "owned_by", using: :btree
    t.index ["statusid"], name: "statusid", using: :btree
  end

  create_table "lovd_variants_on_transcripts", primary_key: ["id", "transcriptid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id",                                      null: false
    t.integer "transcriptid",                limit: 3,   null: false
    t.integer "effectid",                    limit: 1
    t.integer "position_c_start",            limit: 3
    t.integer "position_c_start_intron"
    t.integer "position_c_end",              limit: 3
    t.integer "position_c_end_intron"
    t.string  "VariantOnTranscript/DNA",     limit: 100
    t.string  "VariantOnTranscript/Exon",    limit: 7
    t.string  "VariantOnTranscript/Protein", limit: 100
    t.string  "VariantOnTranscript/RNA",     limit: 100
    t.index ["effectid"], name: "effectid", using: :btree
    t.index ["position_c_start", "position_c_end"], name: "position_c_start", using: :btree
    t.index ["position_c_start", "position_c_start_intron", "position_c_end", "position_c_end_intron"], name: "position_c_start_2", using: :btree
    t.index ["transcriptid"], name: "transcriptid", using: :btree
  end

  add_foreign_key "lovd_active_columns", "lovd_columns", column: "colid", name: "lovd_active_columns_fk_colid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_active_columns", "lovd_users", column: "created_by", name: "lovd_active_columns_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_announcements", "lovd_users", column: "created_by", name: "lovd_announcements_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_announcements", "lovd_users", column: "edited_by", name: "lovd_announcements_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_colleagues", "lovd_users", column: "userid_from", name: "lovd_colleagues_fk_userid_from", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_colleagues", "lovd_users", column: "userid_to", name: "lovd_colleagues_fk_userid_to", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_columns", "lovd_users", column: "created_by", name: "lovd_columns_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_columns", "lovd_users", column: "edited_by", name: "lovd_columns_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_columns2links", "lovd_columns", column: "colid", name: "lovd_columns2links_fk_colid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_columns2links", "lovd_links", column: "linkid", name: "lovd_columns2links_fk_linkid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_diseases", "lovd_users", column: "created_by", name: "lovd_diseases_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_diseases", "lovd_users", column: "edited_by", name: "lovd_diseases_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_genes", "lovd_chromosomes", column: "chromosome", primary_key: "name", name: "lovd_genes_fk_chromosome", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_genes", "lovd_users", column: "created_by", name: "lovd_genes_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_genes", "lovd_users", column: "edited_by", name: "lovd_genes_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_genes", "lovd_users", column: "updated_by", name: "lovd_genes_fk_updated_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_genes2diseases", "lovd_diseases", column: "diseaseid", name: "lovd_genes2diseases_fk_diseaseid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_genes2diseases", "lovd_genes", column: "geneid", name: "lovd_genes2diseases_fk_geneid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_individuals", "lovd_data_status", column: "statusid", name: "lovd_individuals_fk_statusid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals", "lovd_individuals", column: "fatherid", name: "lovd_individuals_fk_fatherid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals", "lovd_individuals", column: "motherid", name: "lovd_individuals_fk_motherid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals", "lovd_individuals", column: "panelid", name: "lovd_individuals_fk_panelid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals", "lovd_users", column: "created_by", name: "lovd_individuals_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals", "lovd_users", column: "edited_by", name: "lovd_individuals_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals", "lovd_users", column: "owned_by", name: "lovd_individuals_fk_owned_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_individuals2diseases", "lovd_diseases", column: "diseaseid", name: "lovd_individuals2diseases_fk_diseaseid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_individuals2diseases", "lovd_individuals", column: "individualid", name: "lovd_individuals2diseases_fk_individualid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_links", "lovd_users", column: "created_by", name: "lovd_links_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_links", "lovd_users", column: "edited_by", name: "lovd_links_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_logs", "lovd_users", column: "userid", name: "lovd_logs_fk_userid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_phenotypes", "lovd_data_status", column: "statusid", name: "lovd_phenotypes_fk_statusid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_phenotypes", "lovd_diseases", column: "diseaseid", name: "lovd_phenotypes_fk_diseaseid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_phenotypes", "lovd_individuals", column: "individualid", name: "lovd_phenotypes_fk_individualid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_phenotypes", "lovd_users", column: "created_by", name: "lovd_phenotypes_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_phenotypes", "lovd_users", column: "edited_by", name: "lovd_phenotypes_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_phenotypes", "lovd_users", column: "owned_by", name: "lovd_phenotypes_fk_owned_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_screenings", "lovd_individuals", column: "individualid", name: "lovd_screenings_fk_individualid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_screenings", "lovd_users", column: "created_by", name: "lovd_screenings_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_screenings", "lovd_users", column: "edited_by", name: "lovd_screenings_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_screenings", "lovd_users", column: "owned_by", name: "lovd_screenings_fk_owned_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_screenings2genes", "lovd_genes", column: "geneid", name: "lovd_screenings2genes_fk_geneid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_screenings2genes", "lovd_screenings", column: "screeningid", name: "lovd_screenings2genes_fk_screeningid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_screenings2variants", "lovd_screenings", column: "screeningid", name: "lovd_screenings2variants_fk_screeningid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_screenings2variants", "lovd_variants", column: "variantid", name: "lovd_screenings2variants_fk_variantid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_shared_columns", "lovd_active_columns", column: "colid", primary_key: "colid", name: "lovd_shared_columns_fk_colid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_shared_columns", "lovd_diseases", column: "diseaseid", name: "lovd_shared_columns_fk_diseaseid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_shared_columns", "lovd_genes", column: "geneid", name: "lovd_shared_columns_fk_geneid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_shared_columns", "lovd_users", column: "created_by", name: "lovd_shared_columns_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_shared_columns", "lovd_users", column: "edited_by", name: "lovd_shared_columns_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_transcripts", "lovd_genes", column: "geneid", name: "lovd_transcripts_fk_geneid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_transcripts", "lovd_users", column: "created_by", name: "lovd_transcripts_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_transcripts", "lovd_users", column: "edited_by", name: "lovd_transcripts_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_users", "lovd_countries", column: "countryid", name: "lovd_users_fk_countryid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_users", "lovd_users", column: "created_by", name: "lovd_users_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_users", "lovd_users", column: "edited_by", name: "lovd_users_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_users2genes", "lovd_genes", column: "geneid", name: "lovd_users2genes_fk_geneid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_users2genes", "lovd_users", column: "userid", name: "lovd_users2genes_fk_userid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_variants", "lovd_alleles", column: "allele", name: "lovd_variants_fk_allele", on_update: :cascade
  add_foreign_key "lovd_variants", "lovd_chromosomes", column: "chromosome", primary_key: "name", name: "lovd_variants_fk_chromosome", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants", "lovd_data_status", column: "statusid", name: "lovd_variants_fk_statusid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants", "lovd_users", column: "created_by", name: "lovd_variants_fk_created_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants", "lovd_users", column: "edited_by", name: "lovd_variants_fk_edited_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants", "lovd_users", column: "owned_by", name: "lovd_variants_fk_owned_by", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants", "lovd_variant_effect", column: "effectid", name: "lovd_variants_fk_effectid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants_on_transcripts", "lovd_transcripts", column: "transcriptid", name: "lovd_variants_on_transcripts_fk_transcriptid", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lovd_variants_on_transcripts", "lovd_variant_effect", column: "effectid", name: "lovd_variants_on_transcripts_fk_effectid", on_update: :cascade, on_delete: :nullify
  add_foreign_key "lovd_variants_on_transcripts", "lovd_variants", column: "id", name: "lovd_variants_on_transcripts_fk_id", on_update: :cascade, on_delete: :cascade
end
