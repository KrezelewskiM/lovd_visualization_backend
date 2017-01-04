require 'sinatra'

require 'pry'
require 'json'
require 'rubygems'
require 'composite_primary_keys'
require 'sprockets'
require 'sass'

require 'sinatra/activerecord'
require 'sinatra/namespace'

class BackendApp < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::ActiveRecordExtension

  # initialize new sprockets environment
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path "assets/stylesheets"
  environment.append_path "assets/javascripts"

  # compress assets
  environment.css_compressor = :scss
  environment.js_compressor  = :uglify

  # get assets
  get "/assets/*" do
    env["PATH_INFO"].sub!("/assets", "")
    settings.environment.call(env)
  end

  get "/variants" do
    haml :variants
  end

  get "/variants_upgrade" do
    haml :variants_upgrade
  end

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
