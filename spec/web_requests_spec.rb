RSpec.describe 'web requests' do
  describe 'GET /' do
    it 'checks production status' do
      expect_any_instance_of(Production).to receive(:success?)
      get '/'
    end

    it 'checks staging status' do
      expect_any_instance_of(Staging).to receive(:success?)
      get '/'
    end
  end

  describe 'GET /production' do
    let(:output) { 'script output' }

    before do
      allow_any_instance_of(Production).to receive(:output).and_return(output)
    end

    it 'displays the test output' do
      get '/production'
      expect(last_response.body).to eql(output)
    end
  end

  describe 'GET /production.json' do
    let(:success) { true }
    let(:json_status) do
      JSON.parse(last_response.body)['status']
    end

    before do
      allow_any_instance_of(Production).to receive(:success?).and_return(success)
      get '/production.json'
    end

    context 'when successful' do
      specify { expect(last_response.headers['Content-Type']).to eql('application/json') }
      specify { expect(json_status).to eql('up') }
    end

    context 'when unsuccessful' do
      let(:success) { false }

      specify { expect(json_status).to eql('down') }
    end
  end

  describe 'GET /staging' do
    let(:output) { 'script output' }

    before do
      allow_any_instance_of(Staging).to receive(:output).and_return(output)
    end

    it 'displays the test output' do
      get '/staging'
      expect(last_response.body).to eql(output)
    end
  end

  describe 'GET /staging.json' do
    let(:success) { true }
    let(:json_status) do
      JSON.parse(last_response.body)['status']
    end

    before do
      allow_any_instance_of(Staging).to receive(:success?).and_return(success)
      get '/staging.json'
    end

    context 'when successful' do
      specify { expect(last_response.headers['Content-Type']).to eql('application/json') }
      specify { expect(json_status).to eql('up') }
    end

    context 'when unsuccessful' do
      let(:success) { false }

      specify { expect(json_status).to eql('down') }
    end
  end

  describe 'POST /production' do
    it 'runs the test' do
      expect_any_instance_of(Production).to receive(:check)
      post '/production'
    end
  end

  describe 'POST /staging' do
    it 'runs the test' do
      expect_any_instance_of(Staging).to receive(:check)
      post '/staging'
    end
  end
end
