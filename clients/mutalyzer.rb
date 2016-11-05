require "httparty"

module Clients
  class Mutalyzer
    include HTTParty

    base_uri "https://mutalyzer.nl/json"
    format :json

    def transcript_info(genomic_reference)
      self.class.get("getTranscriptsAndInfo", query: { genomicReference: genomic_reference })
    end
  end
end
