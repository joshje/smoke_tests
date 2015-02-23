require 'redis'
require 'redis-namespace'

class Environment
  class << self
    def run(command)
      @script = command
    end
    attr_reader :script

    def redis
      @@redis ||= Redis.new(url: ENV['REDISTOGO_URL'])
    end
  end

  def script
    self.class.script
  end

  def check
    output = run_script(script)
    redis.set(:status, exit_status)
    redis.set(:output, output)
  end

  def success?
    redis.get(:status) == '0'
  end

  def output
    redis.get(:output)
  end

  private

  def run_script(command)
    %x(#{command} 2>&1)
  end

  def exit_status
    $?.exitstatus
  end

  def redis
    @redis ||= Redis::Namespace.new(self.class.to_s.downcase, redis: self.class.redis)
  end
end
