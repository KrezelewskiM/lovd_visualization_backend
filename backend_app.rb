require "sinatra"

require "pry"
require 'json'
require 'rubygems'
require 'composite_primary_keys'

require "sinatra/activerecord"
require 'sinatra/namespace'

class BackendApp < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::ActiveRecordExtension

  namespace "/api" do
    get "/detail" do
      content_type :json

      variant = params[:variant]
      transcript = params[:transcript]

      detail_info = Services::DetailInfo.new(transcript, variant)
      detail_info.get_info
    end

    get "/variants" do
      content_type :json

      transcript = params[:transcript]

      Services::VariantsInfo.new(transcript).get_info
    end
  end
end

require_relative "services/detail_info"
require_relative "services/variants_info"
require_relative "models/init"
