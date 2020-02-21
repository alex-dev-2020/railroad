class Train
  attr_reader :name, :current_station

  def initialize (name)
    @name = name
    @speed = 0
  end

  def speed_up(delta)
    @speed += delta
  end

  def speed_down(delta)
    @speed -= delta
    @speed = @speed > 0 ? @speed : stop
  end

  def stop
    @speed = 0
  end

end
