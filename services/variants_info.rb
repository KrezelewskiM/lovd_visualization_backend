require_relative "../clients/mutalyzer"

module Services
  class VariantsInfo
    attr_reader :transcript_id, :transcript

    def initialize(transcript_id)
      @transcript_id = transcript_id
      @transcript = Transcript.find_by(id_ncbi: transcript_id)
    end

    def get_info
      gene = transcript.gene
      response = mutalyzer_client.transcript_info(gene.refseq_UD)
      data = response.find { |entry| entry["name"] =~ /#{gene.id}_.+/ }.symbolize_keys

      process_data(data).to_json
    end

    private

    def mutalyzer_client
      @mutalyzer_client ||= Clients::Mutalyzer.new
    end

    def process_data(data)
      {
        exons: extract_exons(data),
        utr5: extract_utr5(data),
        utr3: extract_utr3(data),
        changes: extract_changes
      }
    end

    def extract_exons(data)
      data[:exons].map { |exon| { start: exon["chromStop"], stop: exon["chromStart"] } }.sort_by { |e| e[:start] }
    end

    def extract_utr3(data)
      { start: data[:chromCDSStart], stop: data[:chromTransStart] }
    end

    def extract_utr5(data)
      { start: data[:chromTransEnd], stop: data[:chromCDSStop] }
    end

    def extract_changes
      transcript.variants.includes(:variants_on_transcript).all.map do |variant|
        {
          start: variant.position_g_start,
          stop: variant.position_g_end,
          type: variant.type,
          url: "#{variant.id}##{variant.variants_on_transcript.transcriptid}",
          frameshift: !!(variant.variants_on_transcript["VariantOnTranscript/Protein"] =~ /.*fs.*/)
        }
      end
    end
  end
end
