class Environment
  class << self
    def run(command)
      @script = command
    end
    attr_reader :script
  end

  def script
    self.class.script
  end

  def check
    run_script(script)
  end

  private

  def run_script(command)
    %x(#{command} 2>&1)
  end
end
