class BackendApp < Sinatra::Base
  get "/" do
    "Hello World!"
  end
end