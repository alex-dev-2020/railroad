# frozen_string_literal: true

require_relative 'made_by'
require_relative 'instance_counter'
require_relative 'valid'
require_relative 'route'

class Train
  attr_reader :name, :type, :wagons, :current_station_index, :number, :list, :route
  include MadeBy
  include InstanceCounter
  include Valid
  @@list = {}
  RGXP_TRAIN_NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i
  TYPES = [
      {
          type: 'CargoTrain',
          name: 'Грузовой'
      },
      {
          type: 'PassTrain',
          name: 'Пассажирский'
      }
  ]
  MANUFACTURERS = [
      {
          name: 'Siemens',
          maker: 'Siemens'
      },
      {
          name: 'Bosh',
          maker: 'Bosh'
      },
      {
          name: 'Tesla',
          maker: 'Tesla'
      }
  ]

  def initialize(number, made_by)
    @number = number
    @made_by = made_by
    @wagons = []
    @speed = 0
    @current_station_index = nil
    @route = nil
    validate!
    @@list[number] = self
    register_instance
  end

  def validate!
    raise StandardError, "Неправильный формат номера (#{self.number})" if self.number !~ RGXP_TRAIN_NUMBER_FORMAT
  end

  def each_wagon
    wagons.each { |wagon| yield(wagon) } if block_given?
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
    @speed =  @speed.positive? ? @speed : stop
  end

  def stop
    @speed = 0
  end

  def to_s
    "Поезд '№#{self.number}' тип '#{self.class}' вагонов '#{wagons_count}'"
  end

  def accept_route(route)
    @route = route
    @current_station_index = 0
    current_station.train_in(self)
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed.zero?
  end

  def wagons_count
    self.wagons.length
  end

  def current_station
    self.station(@current_station_index)
  end

  def previous_station
    self.station(@current_station_index - 1)
  end

  def next_station
    self.station(@current_station_index + 1)
  end

  def move_forward
    if self.next_station.nil?
      raise StandardError, "Это последняя станция маршрута  #{self.route}"
      return
    else
      self.current_station.train_out(number)
      @current_station_index += 1
      self.current_station.train_in(self)
    end
  end

  def move_back
    if self.previous_station.nil?
      raise StandardError, "Это первая станция маршрута  #{self.route}"
      return
    else
      self.current_station.train_out(number)
      @current_station_index -= 1
      self.current_station.train_in(self)
    end
  end

  # private

  protected

  def station(n)
    (n >= 0 && n < self.route.stations.length) ? self.route.stations[n] : nil
  end
end
