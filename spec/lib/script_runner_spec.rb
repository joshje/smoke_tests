require 'lib/script_runner'

RSpec.describe ScriptRunner, '.run' do
  let(:script) { './bin/smoke_test' }
  let(:status) { 0 }
  let(:output) { 'output' }

  before do
    allow(described_class).to receive(:run_script).and_return(output)
    allow(described_class).to receive(:exit_status).and_return(status)
  end

  subject(:result) { described_class.run(script) }

  it { is_expected.to be_a(described_class) }
  specify { expect(result.output).to eq(output) }
  specify { expect(result.status).to eq(status) }
end
