require 'sinatra/base'
require 'json'

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

    def render_as_json(success)
      JSON.generate(
        status: (success) ? 'up': 'down'
      )
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

  get '/production.json' do
    content_type :json
    render_as_json(production.success?)
  end

  get '/staging' do
    content_type :text
    staging.output
  end

  get '/staging.json' do
    content_type :json
    render_as_json(staging.success?)
  end

  post '/production' do
    production.check
  end

  post '/staging' do
    staging.check
  end
end
