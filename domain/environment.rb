require 'redis'
require 'redis-namespace'

class Environment
  class << self
    def run(command)
      @scripts ||= []
      @scripts << command
    end
    attr_reader :scripts

    def redis
      @@redis ||= Redis.new(url: ENV['REDISTOGO_URL'])
    end
  end

  def scripts
    self.class.scripts
  end

  def check
    redis.del(:status, :output)

    scripts.each do |script|
      result = ScriptRunner.run(script)
      redis.set(:status, result.status)
      redis.append(:output, "#{result.output}\n")
      break if result.status != 0
    end
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
