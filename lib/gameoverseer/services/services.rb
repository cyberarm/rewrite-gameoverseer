module GameOverSeer
  module Services
    LIST = []

    def self.register(klass)
      LIST << klass
    end

    def self.enable
      LIST.each do |service|
        service.new.enable
      end
    end
  end
end
