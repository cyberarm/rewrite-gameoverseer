module GameOverseer

  # Services are at the heart on GameOverseer
  #
  # Subclass this class to implement a service
  class Service
    attr_accessor :client_id
    attr_reader :safe_methods

    # Adds the class that subclassed this class to a list for activation later
    # @param subclass [Service]
    def self.inherited(subclass)
      Services.register(subclass)
      GameOverseer::Console.log "Service> added '#{subclass}' to Services::List."
    end

    # This method should not be overridden, you should instead implement {#setup} with no arguments
    def initialize
      if defined?(self.setup)
        @client_id = 0
        @safe_methods = []
        setup
        enable
      end
    end

    # Called before {#enable} there should be no active code here, only setup variables.
    def setup
    end

    # Called when services are first initialized, put active code here, in a thread.
    def enable
    end

    # Called when a message is recieved for this channel.
    # @param data [Hash] The data from the packet
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

    # Sets methods that are safe for {#data_to_method} to call
    # @param array [Array] Array of strings or symbols that match a method in the service class
    def set_safe_methods(array)
      raise "argument must be an array of strings or symbols" unless array.is_a?(Array)
      @safe_methods = array
    end

    # @return [ChannelManager] Active instance of ChannelManager
    def channel_manager
      ChannelManager.instance
    end

    # @return [MessageManager] Instance of MessageManager
    def message_manager
      MessageManager.instance
    end

    # @return [ClientManager] Current instance of ClientManager
    def client_manager
      ClientManager.instance
    end

    # Uses the 'mode' from a packet to call the method of the same name
    # @param data [Hash] data from packet
    def data_to_method(data)
      raise "No safe methods defined!" unless @safe_methods.size > 0
      @safe_methods.each do |method|
        if data['mode'] == method.to_s
          self.send(data['mode'], data)
        end
      end
    end

    # Calls Proc immediately then every milliseconds, async.
    # @param milliseconds [Integer][Float] Time to wait before calling the block
    # @param block [Proc]
    def every(milliseconds, &block)
      Thread.new do
        loop do
          block.call
          sleep(milliseconds/1000.0)
        end
      end
    end

    # Calls Proc after milliseconds have passed, async.
    # @param milliseconds [Integer][Float] Time to wait before calling the block
    # @param block [Proc]
    def after(milliseconds, &block)
      Thread.new do
        sleep(milliseconds/1000.0)
        block.call
      end
    end

    # String to be logged
    # @param string [String] text to log
    # @param color [Gosu::Color] color of text in console
    def log(string, color = Gosu::Color::RED)
      GameOverseer::Console.log_with_color(string, color)
    end
  end
end
