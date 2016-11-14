require "httparty"

module Clients
  class Mutalyzer
    include HTTParty

    base_uri "https://mutalyzer.nl/json"
    format :json

    def transcript_info(genomic_reference)
      self.class.get("getTranscriptsAndInfo", query: { genomicReference: genomic_reference })
    end

    def run_mutalyzer(gene, transcript, variant)
      self.class.get("runMutalyzer", query: { variant: "#{gene}(#{transcript}):#{variant}" })
    end
  end
end
