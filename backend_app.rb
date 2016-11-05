require "sinatra"
require "pry"

class BackendApp < Sinatra::Base
  get "/" do
    Clients::Mutalyzer.test
  end
end

require_relative "clients/mutalyzer"
