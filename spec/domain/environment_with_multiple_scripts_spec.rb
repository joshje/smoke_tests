require 'domain/environment'
require 'lib/script_runner'

RSpec.describe Environment, 'with multiple scripts' do
  let(:script_1) { './bin/script_1' }
  let(:script_2) { './bin/script_2' }
  let(:environment_name) { 'testing_more' }
  let(:environment_class) do
    if Object.const_defined?(environment_name.capitalize)
      Object.const_get(environment_name.capitalize)
    else
      str_1 = script_1
      str_2 = script_2
      Object.const_set(environment_name.capitalize, Class.new(described_class) do
        run str_1
        run str_2
      end)
    end
  end
  let(:status_field) { "#{environment_name}:status" }
  let(:output_field) { "#{environment_name}:output" }
  let(:status_1) { 0 }
  let(:output_1) { 'output 1' }
  let(:status_2) { 0 }
  let(:output_2) { 'output 2' }
  let(:result_1) { double(output: output_1, status: status_1) }
  let(:result_2) { double(output: output_2, status: status_2) }
  let(:redis) { Redis.new }

  subject(:environment) { environment_class.new }

  before do
    redis.flushdb
  end

  specify { expect(environment.scripts).to eql([script_1, script_2]) }

  describe '#check' do
    before do
      allow(ScriptRunner).to receive(:run).with(script_1).and_return(result_1)
      allow(ScriptRunner).to receive(:run).with(script_2).and_return(result_2)
      environment.check
    end

    context 'when all scripts pass' do
      specify { expect(redis.get(status_field)).to eql('0') }
      specify { expect(redis.get(output_field)).to eql("#{output_1}\n#{output_2}\n") }
    end

    context 'when the first script fails' do
      let(:status_1) { 1 }

      specify { expect(redis.get(status_field)).to eql('1') }
      specify { expect(redis.get(output_field)).to eql("#{output_1}\n") }
    end

    context 'when the second script fails' do
      let(:status_2) { 1 }

      specify { expect(redis.get(status_field)).to eql('1') }
      specify { expect(redis.get(output_field)).to eql("#{output_1}\n#{output_2}\n") }
    end
  end
end
