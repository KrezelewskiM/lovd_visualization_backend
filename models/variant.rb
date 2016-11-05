class Variant < ActiveRecord::Base
  self.table_name = "lovd_variants"
  self.inheritance_column = "pass"

  has_many :variants_on_transcripts, foreign_key: "id"
end
