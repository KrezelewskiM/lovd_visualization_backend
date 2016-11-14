require_relative "../clients/mutalyzer"

module Services
  class VariantsInfo
    attr_reader :transcript

    def initialize(transcript)
      @transcript = transcript
    end

    def get_info
      gene = Transcript.find_by(id_ncbi: transcript).gene
      response = mutalyzer_client.transcript_info(gene.refseq_UD)
      response.find { |entry| entry["name"] =~ /#{gene.id}_.+/ }.to_json
    end

    private

    def mutalyzer_client
      @mutalyzer_client ||= Clients::Mutalyzer.new
    end
  end
end
