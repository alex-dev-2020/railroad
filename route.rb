class Route
  attr_reader :stations
  include InstanceCounter
  @@list = []

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    @@list << self
    register_instance
  end

  def self.list
    @@list
  end

  def add_station(station)
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