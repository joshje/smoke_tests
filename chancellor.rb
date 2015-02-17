require 'sinatra/base'

class Chancellor < Sinatra::Base
  get '/' do
    @staging = false
    @production = true
    erb :index
  end
end
