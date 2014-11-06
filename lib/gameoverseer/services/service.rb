module GameOverSeer
  class Service
    def self.inherited(subclass)
      puts "New service '#{subclass}' added to ServicesList."
    end

    def initialize
      if self.defined?(setup)
        setup
      end
    end

    def version
      raise "Method 'version' on class '#{self}' not defined, see '#{__FILE__}' in GameOverseer source."
      # Please use the sematic versioning system,
      # http://semver.org
      #
      # e.g. "1.5.9" (Major.Minor.Patch)
    end
  end
end
