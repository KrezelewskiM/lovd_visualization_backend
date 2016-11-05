require_relative "../clients/mutalyzer"

module Services
  class DetailInfo
    attr_reader :transcript, :variant, :build

    def initialize(transcript, variant, build)
      @transcript = transcript
      @variant = variant
      @build = build
    end

    def get_info
      mutalyzer_client.transcript_info(transcript).to_json
    end

    private

    def mutalyzer_client
      @mutalyzer_client ||= Clients::Mutalyzer.new
    end
  end
end
