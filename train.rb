class Train
  attr_reader :id, :wagons, :current_station

  def initialize (id, wagons)
    @id = id
    # нужно придумать отностиельно вагонов при инициализации поезда 
    # @wagons = wagons
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
