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
end
