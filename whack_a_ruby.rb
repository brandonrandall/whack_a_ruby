require 'gosu'

class WhackARuby < Gosu::Window

  def initialize
    super( 950, 725 )
    self.caption = 'Whack the Ruby!'
    @background = Gosu::Image.new(self, 'wallup-26625.png')
    @ruby = Gosu::Image.new(self, 'karthikeyan-ruby-flatmix-200px.png' )
    @hammer = Gosu::Image.new('rejon-Hammer-200px.png')
    @x = 200
    @y = 200
    @height = 50
    @width = 43
    @velocity_x = 10
    @velocity_y = 5
    @visible = 0
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true
    @start_time = 0
  end

  def update
    if @playing
      @x += @velocity_x
      @y += @velocity_y
      @visible -= 0.5
      @time_left = (30 - ((Gosu.milliseconds - @start_time))/1000)
      @playing = false if @time_left <= 0
      @velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      @visible = 30 if @visible < -10 && rand < 0.01
    end
  end

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1
          @score += 15
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      if (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end

  def draw
    # @background.draw(0,0,0)
    # @hammer.draw(@x - @width/2, @y - @height/2, 1)
    if @visible > 0
      @ruby.draw(@x - @width/2, @y - @height/2, 1)
    end
    @hammer.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0,0,c,950,0,c,950,725,c,0,725,c)
    @hit = 0
    @font.draw(@score.to_s, 25, 10, 2)
    @font.draw(@time_left.to_s, 475, 10, 2)
    unless @playing
      @font.draw('Game Over', 300, 300, 3)
      @font.draw('Press Space Bar to Play Again', 175, 350, 3)
      @visible = 20
    end
  end

end

window = WhackARuby.new
window.show
