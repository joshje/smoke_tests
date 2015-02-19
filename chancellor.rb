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
    content_type :text
    production.output
  end

  get '/staging' do
    content_type :text
    staging.output
  end

  post '/production' do
    production.check
  end

  post '/staging' do
    staging.check
  end
end
