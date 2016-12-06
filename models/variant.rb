class Variant < ActiveRecord::Base
  self.table_name = "lovd_variants"
  self.inheritance_column = "pass"

  has_one :variants_on_transcript, foreign_key: "id"
end
