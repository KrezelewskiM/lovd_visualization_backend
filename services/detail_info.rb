require_relative "../clients/mutalyzer"

module Services
  class DetailInfo
    attr_reader :transcript, :variant

    def initialize(transcript, variant)
      @transcript = transcript
      @variant = variant
    end

    def get_info
      gene = Transcript.find_by(id_ncbi: transcript).gene.refseq_UD
      mutalyzer_client.run_mutalyzer(gene, transcript, variant).to_json
    end

    private

    def mutalyzer_client
      @mutalyzer_client ||= Clients::Mutalyzer.new
    end
  end
end
