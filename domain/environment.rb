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
    result = ScriptRunner.run(script)
    redis.set(:status, result.status)
    redis.set(:output, result.output)
  end

  def success?
    redis.get(:status) == '0'
  end

  def output
    redis.get(:output)
  end

  private

  def redis
    @redis ||= Redis::Namespace.new(self.class.to_s.downcase, redis: self.class.redis)
  end
end
