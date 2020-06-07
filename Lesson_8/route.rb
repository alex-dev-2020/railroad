# frozen_string_literal: true

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
    raise StandardError, 'Начальная и конечная  станции маршрута должны различаться' if stations[0] == stations[1]
  end

  def to_s
    "Маршрут '#{stations.first.name} -> #{stations.last.name}'"
  end

  def self.list
    @@list
  end

  def add_station(station)
    raise StandardError, "Маршрут уже содержит станцию:'#{station.name}'" if stations.include? (station)

    stations.insert(-2, station)
  end

  def delete_station(station)
    raise StandardError,'Конечные точки маршрута удалить нельзя' if station == stations.first || station == stations.last
    raise StandardError, "Маршрут не содержит станцию'#{station.name}'" if ! stations.include?(station)

    stations.delete(station)
  end

end
