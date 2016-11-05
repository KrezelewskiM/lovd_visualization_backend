class VariantsOnTranscript < ActiveRecord::Base
  self.table_name = "lovd_variants_on_transcripts"
  self.primary_keys = :id, :transcriptid

  belongs_to :variant, foreign_key: "id"
  belongs_to :transcript, foreign_key: "transcriptid"
end
