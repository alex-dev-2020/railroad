class Train
  attr_reader :name, :wagons, :current_station

  def initialize (name)
    @name = name
    @wagons = ['zero_wagon','test_wagon']
    @speed = 0
    # wagon_quantity.times { add_wagon }
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

  def add_wagon
    @wagons += 1 if @speed == 0
  end

  def detach_wagon
    @wagons -= 1 if @speed == 0 && wagons > 0
  end

  def accept_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station_index = @route.stations.index(@current_station)
    @current_station.train_in(self)
  end
end
