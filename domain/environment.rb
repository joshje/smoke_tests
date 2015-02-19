require 'fakeredis'

class Environment
  class << self
    def run(command)
      @script = command
    end
    attr_reader :script

    def redis
      @redis ||= Redis.new
    end
  end

  def script
    self.class.script
  end

  def check
    output = run_script(script)
    self.class.redis.set("#{self.class.to_s.downcase}_status", exit_status)
    self.class.redis.set("#{self.class.to_s.downcase}_output", output)
  end

  def success?
    self.class.redis.get("#{self.class.to_s.downcase}_status") == '0'
  end

  private

  def run_script(command)
    %x(#{command} 2>&1)
  end

  def exit_status
    $?.exitstatus
  end
end
