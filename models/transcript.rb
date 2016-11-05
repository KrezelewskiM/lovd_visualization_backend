class Transcript < ActiveRecord::Base
  self.table_name = "lovd_transcripts"

  has_many :variants_on_transcripts, foreign_key: "transcriptid"
  has_many :variants, through: :variants_on_transcripts
  belongs_to :gene, foreign_key: "geneid"
end
