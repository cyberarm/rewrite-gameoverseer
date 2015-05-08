module GameOverseer
  class Console < Gosu::Window
    include Celluloid
    # TODO: Use Gosu::Window.record to lower number of objects that need to be drawn

    PENDING_LOG = []
    def initialize
      GameOverseer::Console.instance = self
      super(720, 480, false)
      $window = self
      $window.caption = "GameOverseer Console"
      $window.text_input = Gosu::TextInput.new

      @default_text_instance = Gosu::Font.new($window, 'Consolas', 18)
      @messages = []
      setup_ui
    end

    def needs_cursor?
      true
    end

    def draw
      @ui_image.draw(0,0,0) if defined?(@ui_image)
    end

    def update
      update_ui
      @ui_image = $window.record(720, 480) {draw_ui}
    end

    def setup_ui
      @current_text = text_instance
      @current_text_x = 4

      # Required first message
      @messages << {
        text: '',
        instance: text_instance,
        color: Gosu::Color::WHITE,
        x: 4,
        y: 480-26-18,
        z: 1
      }

      submit_text("#{Time.now.strftime('%c')}", false)
    end

    def draw_ui
      draw_rect(0,0, 720, 26, Gosu::Color.rgb(200, 75, 25))
      draw_rect(0,454, 720, 480, Gosu::Color::WHITE)
      text_instance.draw("GameOverSeer Console. GameOverseer version #{GameOverSeer::VERSION} #{GameOverSeer::RELEASE_NAME} #{@messages.count}", 4, 4, 3)
      @current_text.draw("#{$window.text_input.text}", @current_text_x, 458, 3, 1, 1, Gosu::Color::BLACK)
      draw_rect(@caret+@current_text_x, 456, 2.0+@caret+@current_text_x, 474, Gosu::Color::BLUE, 4) if defined?(@caret) && @render_caret

      @messages.each do |message|
        message[:instance].draw(message[:text],message[:x],message[:y],message[:z], 1, 1, message[:color])
        p message[:color] unless message[:color] == Gosu::Color::WHITE
      end
    end

    def update_ui
      PENDING_LOG.each do |log_message|
        submit_text(log_message, false) if log_message.strip.length > 0
        PENDING_LOG.delete(log_message)
      end

      @caret = @current_text.text_width($window.text_input.text[0...$window.text_input.caret_pos])

      @caret_tick = 0 unless defined?(@caret_tick)
      @render_caret = true if @caret_tick < 15
      @render_caret = false if @caret_tick > 30

      @caret_tick = 0 unless @caret_tick < 45
      @caret_tick+=1

      value = @current_text.text_width($window.text_input.text)+@current_text_x
      if value >= 720
        @current_text_x-=4
      elsif value <= 715
        @current_text_x+=4 unless @current_text_x >= 4
      end
    end

    def text_instance
      @default_text_instance
    end

    def draw_rect(x1,y1, x2,y2, color = Gosu::Color::GRAY, z = 2)
      $window.draw_quad(x1, y1, color, x2, y1, color, x1, y2, color, x2, y2, color, z)
    end

    def scroll(direction)
      case direction
      when :down
        if @messages.last[:y] >= 480 - 26 - 18
          @messages.each do |message|
            message[:y]-=18
          end
        end
      when :up
        if @messages.first[:y] <= 26#<= 480 - 26 - 32
          @messages.each do |message|
            message[:y]+=18
          end
        end
      end
    end

    def clean_messages(count)
      if @messages.count >= count
        @messages.delete(@messages.first)
      end
    end

    def button_up(id)
      case id
      when 41 # Escape
        # Quit?
      when 40 # Enter
        submit_text($window.text_input.text)
      when 88 # Numpad Enter
        submit_text($window.text_input.text)
      when 259 # Mouse wheel
        scroll(:up)
      when 260  # Mouse wheel
        scroll(:down)
      end
    end

    def self.instance
      @instance
    end

    def self.instance=_instance
      @instance = _instance
    end

    def self.log(string)
      self.log_it(string) if string.strip.length > 0
      begin
        GameOverseer::Console.instance.submit_text(string, false)
      rescue NoMethodError
        self.defer_log(string)
      end
    end

    def self.log_with_color(string, color = Gosu::Color::WHITE)
      self.log_it(string) if string.strip.length > 0
      GameOverseer::Console.instance.submit_text(string, false, color)
    end

    def self.defer_log(string)
      PENDING_LOG << string
    end

    def self.log_it(string)
      puts string
      retry_limit = 0
      begin
        @log_file = File.open("#{Dir.pwd}/logs/log-#{Time.now.strftime('%B-%d-%Y')}.txt", 'a+') unless defined? @log_file
        @log_file.write "[#{Time.now.strftime('%c')}] #{string}\n"
      rescue Errno::ENOENT
        Dir.mkdir("#{Dir.pwd}/logs") unless File.exist?("#{Dir.pwd}/logs") && File.directory?("#{Dir.pwd}/logs")
        retry_limit+=1
        retry unless retry_limit >= 2
      end
    end

    protected
    def submit_text(text, from_console = true, color = Gosu::Color::WHITE)
      if text.strip.length > 0
        clean_messages(300)
        text = "Console> #{text}" if from_console
        GameOverseer::Console.log_it(text)
        if text.length > 83
          temp_text = text[0..83]
          @messages.each do |message|
            message[:y]-=18
          end
          @messages << {
            text: temp_text,
            instance: text_instance,
            color: color,
            x: 4,
            y: @messages.last[:y] + 18,
            z: 1
          }
          submit_text(text[83..text.length], false)
        else
          @messages.each do |message|
            message[:y]-=18
          end
          @messages << {
            text: text,
            instance: text_instance,
            color: color,
            x: 4,
            y: @messages.last[:y] + 18,
            z: 1
          }
        end
        $window.text_input = Gosu::TextInput.new if from_console
      end
    end
  end
end
