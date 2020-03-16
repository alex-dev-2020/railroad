class Route
  attr_reader :stations
  include InstanceCounter

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
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