class Route
  attr_reader :stations
  include InstanceCounter
  include Valid
  @@list = []

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    @@list << self
    register_instance
  end

  def validate!
    raise StandardError, 'Начальная и конечная  станции маршрута должны различаться' if self.stations[0] == self.stations[1]
  end

  def self.list
    @@list
  end

  def add_station(station)
    raise StandardError, "Маршрут уже содержит станцию'#{station}'" if stations.include? (station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    if (station != @stations.first) && (station != @stations.last)
      @stations.delete(station)
    else
      puts 'Конечные точки маршрута удалить нельзя!'
    end
  end
end