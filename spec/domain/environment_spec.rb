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

  subject(:environment) { environment_class.new }

  specify { expect(environment.script).to eql(script_to_run) }

  describe '#check' do
    it 'runs the script' do
      expect(environment).to receive(:run_script).with(script_to_run)
      environment.check
    end
  end
end
