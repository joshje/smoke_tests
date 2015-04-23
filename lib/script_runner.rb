class ScriptRunner < Struct.new(:output, :status)
  class << self
    def run(script)
      new(run_script(script), exit_status)
    end

    private

    def run_script(command)
      %x(#{command} 2>&1)
    end

    def exit_status
      $?.exitstatus
    end
  end
end
