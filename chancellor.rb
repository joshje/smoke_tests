require 'sinatra/base'

require_relative 'domain/staging'
require_relative 'domain/production'

class Chancellor < Sinatra::Base
  helpers do
    def production
      @productionn ||= Production.new
    end

    def staging
      @staging ||= Staging.new
    end
  end

  get '/' do
    @staging = staging.success?
    @production = production.success?
    erb :index
  end

  get '/production' do
    production.output
  end

  get '/staging' do
    staging.output
  end

  post '/production' do
    production.check
  end
end
