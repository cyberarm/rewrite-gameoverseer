module GameOverseer
  class Console < Gosu::Window
    def initialize
      super(720, 480, false)
      $window = self
      $window.caption = "GameOverseer Console"
      $window.text_input = Gosu::TextInput.new

      @default_text_instance = Gosu::Font.new($window, 'Consolas', 18)
      @messages = []
      @messages_cleaned = true

      setup_ui
    end

    def needs_cursor?
      true
    end

    def draw
      draw_ui
    end

    def update
      update_ui
    end

    def setup_ui
      @current_text = text_instance
      @current_text_x = 4
      @messages << {
        text: "Good Morning!",
        instance: text_instance,
        x: 4,
        y: 428,
        z: 1
        }
    end

    def draw_ui
      draw_rect(0,0, 720, 26, Gosu::Color::RED)
      draw_rect(0,454, 720, 480, Gosu::Color::WHITE)
      text_instance.draw("GameOverSeer Console. GameOverseer version #{GameOverSeer::VERSION}-#{GameOverSeer::RELEASE_NAME}-#{@messages.count}", 4, 4, 3)
      @current_text.draw("#{$window.text_input.text}", @current_text_x, 458, 3,  1,1, Gosu::Color::BLACK)
      draw_rect(@caret+@current_text_x, 456, 2.0+@caret+@current_text_x, 474, Gosu::Color::BLUE, 4) if defined?(@caret) && @render_caret

      @messages.each do |message|
        message[:instance].draw(message[:text],message[:x],message[:y],message[:z])
      end
    end

    def update_ui
      @clean_tick = 0 unless defined?(@clean_tick)

      if @clean_tick >= 120
        count = @messages.count
        if count >= 567
          clean_messages(567) if @messages_cleaned
        end
        @clean_tick = 0
      end
      @clean_tick+=1

      @caret = @current_text.text_width($window.text_input.text[0...$window.text_input.caret_pos])

      @caret_tick = 0 unless defined?(@caret_tick)
      @render_caret = true if @caret_tick < 30
      @render_caret = false if @caret_tick > 30

      @caret_tick = 0 unless @caret_tick < 60
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

    def draw_rect(x1,y1, x2,y2, color=Gosu::Color::GRAY, z=2)
      $window.draw_quad(x1, y1, color, x2, y1, color, x1, y2, color, x2, y2, color, z)
    end

    def submit_text(text)
      if text.length > 0
        @messages.each do |message|
          message[:y]-=18
        end
        @messages << {
          text: text,
          instance: text_instance,
          x: 4,
          y: @messages.last[:y]+18,
          z: 1
          }
        $window.text_input = Gosu::TextInput.new
      end
    end

    def scroll(direction)
      case direction
      when :up
        if @messages.last[:y] >= 480-26-18
          @messages.each do |message|
            message[:y]-=18
          end
        end
      when :down
        if @messages.first[:y] <= 26#<= 480-26-32
          @messages.each do |message|
            message[:y]+=18
          end
        end
      end
    end

    def clean_messages(count)
      @messages_cleaned = false
      Thread.start do
        while @messages.count >= count
          @messages.delete(@messages.first)
        end
        @messages_cleaned = true
      end
    end

    def button_up(id)
      case id
      when 41
        # Quit?
      when 40
        submit_text($window.text_input.text)
      when 88
        submit_text($window.text_input.text)
      when 259
        scroll(:up)
      when 260
        scroll(:down)
      when 43
        1000.times do
          submit_text("#{SecureRandom.uuid} #{SecureRandom.hex} #{SecureRandom.base64}")
        end
      end
    end
  end
end
