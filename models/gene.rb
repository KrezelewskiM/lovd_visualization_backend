class Gene < ActiveRecord::Base
  self.table_name = "lovd_genes"

  has_many :transcripts, foreign_key: "geneid"
end
