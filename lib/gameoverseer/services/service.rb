module GameOverseer
  class Service
    attr_accessor :client_id

    def self.inherited(subclass)
      GameOverseer::Console.log "Service> added '#{subclass}' to Services::List."
      Services.register(subclass)
    end

    def initialize
      if defined?(self.setup)
        @client_id = 0
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
      self.send(data['mode'], data)
      [self.methods - Class.methods].each do |method|
        if data['mode'] == method.to_s
          self.send(data['mode'], data)
        end
      end
    end

    def log(string, color = Gosu::Color::RED)
      GameOverseer::Console.log_with_color(string, color)
    end
  end
end
