require_relative "../clients/mutalyzer"

module Services
  class VariantsInfo
    attr_reader :build, :transcript

    def initialize(build, transcript)
      @build = build
      @transcript = transcript
    end

    def get_info
      [webservice_part, database_part].to_json
    end

    private

    def webservice_part
      mutalyzer_client.transcript_info(transcript)
    end

    def database_part
      transcript_record = Transcript.find_by(id_ncbi: transcript)
      transcript_record.variants.all
    end

    def mutalyzer_client
      @mutalyzer_client ||= Clients::Mutalyzer.new
    end
  end
end
