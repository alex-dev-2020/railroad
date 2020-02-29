class Train
  attr_reader :name, :type, :wagons, :current_station

  def initialize (name)
    @name = name
    @wagons = ['zero_wagon', 'test_wagon']
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

  def accept_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station_index = @route.stations.index(@current_station)
    @current_station.train_in(self)
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed == 0
  end

  def previous_station
    previous_station = (@current_station != @route.stations.first) ? @route.stations[@current_station_index - 1] : warning_route_border
  end

  def next_station
    next_station = (@current_station != @route.stations.last) ? @route.stations[@current_station_index + 1] : warning_route_border
  end

  def warning_route_border
    puts "Граница маршрута"
  end

  def move_forward
    @current_station.train_out(self)
    next_station.train_in(self)
    @current_station_index += 1
  end

  def move_back
    @current_station.train_out(self)
    previous_station.train_in(self)
    @current_station_index -= 1
  end
end
