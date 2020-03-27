require_relative 'made_by'
require_relative 'instance_counter'
require_relative 'valid'

class Train
  attr_reader :name, :type, :wagons, :current_station, :number, :list
  include MadeBy
  include InstanceCounter
  include Valid
  @@list = {}
  RGXP_TRAIN_NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i

  def initialize (name, number, made_by)
    @name = name
    @number = number
    @made_by = made_by
    @wagons = []
    @speed = 0
    @@list[number] = self
    validate!
    register_instance
  end

  def validate!
    raise StandardError, "Неправильный формат номера (#{self.number})" if self.number !~ RGXP_TRAIN_NUMBER_FORMAT
  end

  def self.list
    @@list
  end

  def self.find(number)
    @@list[number]
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
