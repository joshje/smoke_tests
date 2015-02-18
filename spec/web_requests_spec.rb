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
end
