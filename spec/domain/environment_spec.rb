require 'domain/environment'

RSpec.describe Environment do
  let(:script_to_run) { './bin/smoke_test' }
  let(:environment_name) { 'testing' }
  let(:environment_class) do
    if Object.const_defined?(environment_name.capitalize)
      Object.const_get(environment_name.capitalize)
    else
      str = script_to_run
      Object.const_set(environment_name.capitalize, Class.new(described_class) do
        run str
      end)
    end
  end
  let(:status_field) { "#{environment_name}:status" }
  let(:output_field) { "#{environment_name}:output" }
  let(:status) { 0 }
  let(:output) { 'output' }
  let(:redis) { Redis.new }

  subject(:environment) { environment_class.new }

  before do
    redis.flushdb
  end

  specify { expect(environment.script).to eql(script_to_run) }

  describe '#check' do
    before do
      allow(environment).to receive(:run_script).with(script_to_run).and_return(output)
      allow(environment).to receive(:exit_status).and_return(status)
      environment.check
    end

    specify { expect(redis.get(status_field)).to eql(status.to_s) }
    specify { expect(redis.get(output_field)).to eql(output) }
  end

  describe '#success?' do
    before do
      redis.set(status_field, status)
    end

    context 'when zero' do
      specify { expect(environment.success?).to be_truthy }
    end

    context 'when non-zero' do
      let(:status) { "1" }

      specify { expect(environment.success?).to be_falsy }
    end
  end

  describe '#output' do
    before do
      redis.set(output_field, output)
    end

    specify { expect(environment.output).to eq(output) }
  end
end
