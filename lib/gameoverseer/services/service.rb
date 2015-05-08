module GameOverseer
  class Service
    attr_accessor :client_id
    attr_reader :safe_methods

    def self.inherited(subclass)
      Services.register(subclass)
      GameOverseer::Console.log "Service> added '#{subclass}' to Services::List."
    end

    def initialize
      if defined?(self.setup)
        @client_id = 0
        @safe_methods = []
        setup
      end
    end

    # Called before 'enable' there should be no active code here, only setup variables.
    def setup
    end

    # Called when services are first initialized, put active code here.
    def enable
    end

    # Called when a message is recieved for this channel.
    def process(data)
    end

    def version
      # Please use the sematic versioning system,
      # http://semver.org
      #
      # e.g.
      # "1.5.9"
      # (Major.Minor.Patch)
      "0.0.0-default"
    end

    # Sets methods that are safe for `data_to_method` to call
    def set_safe_methods(array)
      raise "argument must be an array of strings or symbols" unless array.is_a?(Array)
      @safe_methods = array
    end

    protected
    def channel_manager
      ChannelManager.instance
    end

    def message_manager
      MessageManager.instance
    end

    def client_manager
      ClientManager.instance
    end

    def data_to_method(data)
      @safe_methods.each do |method|
        if data['mode'] == method.to_s
          self.send(data['mode'], data)
        end
      end
    end

    # Calls Proc immediately then every milliseconds, async.
    def every(milliseconds, &block)
      Thread.new do
        loop do
          block.call
          sleep(milliseconds/1000.0)
        end
      end
    end

    # Calls Proc after milliseconds have passed, async.
    def after(milliseconds, &block)
      Thread.new do
        sleep(milliseconds/1000.0)
        block.call
      end
    end

    def log(string, color = Gosu::Color::RED)
      GameOverseer::Console.log_with_color(string, color)
    end
  end
end
