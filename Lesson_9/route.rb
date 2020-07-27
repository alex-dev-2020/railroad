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
    # register_instance
  end

  def validate!
    raise StandardError, 'Станции должны различаться' if stations[0] == stations[-1]
  end

  def to_s
    "Маршрут '#{stations.first.name} -> #{stations.last.name}'"
  end

  def self.list
    @@list
  end

  def add_station(station)
    if stations.include? station
      raise StandardError, "Маршрут уже содержит станцию:'#{station.name}'"
    end

    stations.insert(-2, station)
  end

  def delete_station(station)
    raise StandardError, 'Промежуточные станции в маршруте отсутствуют' unless stations.length > 2
    unless stations.include? station
      raise StandardError, "Маршрут не содержит станцию #{station.name}"
    end
    if station.trains_count.positive?
      raise StandardError, "На станции '#{station.name}' размещены поезда"
    end

    stations.delete(station)
  end
end
