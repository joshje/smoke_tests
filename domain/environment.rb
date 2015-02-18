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
end
