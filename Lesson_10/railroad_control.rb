# frozen_string_literal: true

# class Railroad

require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'pass_wagon'
require_relative 'route'
require_relative 'seed'
require_relative 'instance_counter'
require_relative 'made_by'
require_relative 'accessors'

# rubocop:disable Metrics/ClassLength

class RailroadControl
  include Seed
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
  end

  def validate!(index, object)
    raise "Индекс не существует (#{index})" if !index.is_a?(Integer) || object[index].nil?
  end

  # txt menu
  def selection(menu)
    menu.each { |key, value| puts "#{key} - #{value}" }
    puts 'Выбран пункт:'
    gets.chomp
  end

  def create_station
    begin
      station_name = gets_station_name
      station = Station.new(station_name)
    rescue StandardError => e
      puts e
      retry
    end
    @stations << station
    puts "Создана станция'#{station.name}'"
  end

  def print_stations_only
    print_stations
  end

  def print_stations
    stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
  end

  def print_trains_on_one_station
    raise StandardError, 'Нет станций' if stations.empty?

    station = gets_station
    puts "Станция: #{station.name} (поездов: #{station.trains.length})"
    print_trains_on_station(station)
  end

  def print_trains_on_each_station
    raise StandardError, 'Нет станций' if stations.empty?

    stations.each do |station|
      puts "#{station.name}"
      print_trains_on_station(station)
      puts
    end
  end

  def add_station_to_route
    raise StandardError, 'Список маршрутов пуст' if routes.empty?

    route = gets_route
    station = gets_station
    route.add_station(station)
    puts "Станция '#{station.name}' добавлена в маршрут #{route.to_s}"
  end

  def delete_station_from_route
    raise StandardError, 'Список маршрутов пуст' if routes.empty?

    route = gets_route
    station = gets_station
    route.delete_station(station)
    puts "Станция '#{station.name}' удалена из маршрута #{route.to_s}"
  end

  def create_train
    type_index = gets_train_type_index
    maker = gets_train_manufacturer
    train_number = gets_train_number

    case Train::TYPES[type_index][:type]
    when 'CargoTrain'
      train = CargoTrain.new(train_number, maker)
    when 'PassTrain'
      train = PassTrain.new(train_number, maker)
    end

    puts "Создан поезд #{train.to_s}"
    @trains << train
  end

  def print_trains
    puts 'Существующие поезда:'
    trains.each_with_index { |train, index| puts "[#{index}] #{train}" }
  end

  def create_route
    raise StandardError, 'Нужны минимум 2 созданные станции' if stations.length < 2

    first_station = gets_station { puts 'Начальная станция:' }
    last_station = gets_station { puts 'Конечная станция:' }

    @routes << Route.new(first_station, last_station)

    puts "Маршрут '#{first_station.name} -> #{last_station.name}' создан"
  end

  def print_routes
    puts 'Существующие маршруты:'
    routes.each_with_index { |route, index| puts "[#{index}] #{route}" }
  end

  def print_routes_stations
    route = gets_route
    print_route_stations(route)
  end

  def print_route_stations(route)
    puts "Маршрут #{route.to_s} содержит следующие станции:"
    route.stations.each_with_index do |station, index|
      puts "[#{index}] #{station.name}"
    end
  end

  def add_route_to_train
    raise StandardError, 'Список поездов пуст' if trains.empty?
    raise StandardError, 'Список маршрутов пуст' if routes.empty?

    route = gets_route
    train = gets_train
    train.accept_route(route)
    puts "Mаршрут #{route.to_s} назначен поезду #{train.number}"
  end

  def move_train_forward
    move_train(:move_forward)
  end

  def move_train_back
    move_train(:move_back)
  end

  def add_wagon
    train = gets_train

    train_class = train.class
    if train_class == CargoTrain
      begin
        wagon = create_cargo_wagon
      rescue StandardError => e
        puts e
        return
      end
    elsif train_class == PassTrain
      begin
        wagon = create_pass_wagon
      rescue StandardError => e
        puts 'Ошибка создания вагона'
        puts e
        return
      end
    end
    train.add_wagon(wagon)
    puts "Вагон № #{wagon.number} тип #{wagon.class} добавлен к поезду №#{train.number}"
  end

  def detach_wagon
    train = gets_train
    if train.wagons.empty?
      puts 'У данного поезда нет вагонов'
      return
    else
      train.wagons.pop
    end

    puts "Вагон отцеплен от поезда №#{train.number}"
  end

  def print_trains_wth_wagons
    train = gets_train
    puts "Вагоны поезда #{train.to_s}:"
    print_wagons(train)
  end

  def print_wagons(train)
    raise StandardError, 'У данного поезда нет вагонов' if train.wagons.empty?

    train.wagons.each_with_index { |wagon, index| puts "[#{index}] #{wagon.to_s}" }
  end

  def load_wagon
    wagon = gets_wagon
    if wagon.class == CargoWagon
      begin
        load_cargo_wagon(wagon)
      rescue StandardError => e
        puts e
        return
      end
    else
      begin
        occupy_seats(wagon)
      rescue StandardError => e
        puts e
        return
      end
    end
    puts "#{wagon.to_s}"
  end

  def unload_wagon
    wagon = gets_wagon

    if wagon.class == CargoWagon
      begin
        unload_cargo_vagon(wagon)
      rescue StandardError => e
        puts e
        nil
      end
    elsif wagon.class == PassWagon
      begin
        leave_seat(wagon)
      rescue StandardError => e
        puts e
        nil
      end
    else
      puts 'Вагон неизвестного типа'

      puts "#{wagon.to_s}"
    end
  end

  def station_history
    train = gets_train
    puts "История перемещения поезда #{train}"
    train.visited_station_history.each_with_index do |station, index|
      puts "[#{index}] #{station.name}"
    end
  end

  def wagon_using_history
    wagon = gets_wagon
    puts "Статистика использования вагонa #{wagon.number}"
    wagon.load_using_history.each_with_index do |load, index|
      puts "[#{index}] [#{load}]"
    end
  end

  private

  def gets_station_name
    puts 'Введите название станции'
    gets.chomp.strip
  end

  def gets_station
    yield if block_given?
    station_index = gets_station_index
    validate!(station_index, stations)
    stations[station_index]
  end

  def gets_route
    raise StandardError, 'Список маршрутов пуст!' if routes.empty?

    print_routes
    route_index = gets_route_index
    validate!(route_index, routes)
    routes[route_index]
  end

  def gets_train
    raise StandardError, 'Список поездов пуст!' if trains.empty?

    train_index = gets_train_index
    validate!(train_index, trains)
    trains[train_index]
  end

  def gets_wagon
    train = gets_train
    print_wagons(train)
    puts 'Введите индекс вагона'
    wagon_index = gets_integer
    validate!(wagon_index, train.wagons)
    train.wagons[wagon_index]
  end

  def gets_train_type_index
    train_types
    puts 'Введите индекс типа поезда:'
    gets_integer
  end

  def train_types
    Train::TYPES.each_with_index do |train_type, index|
      puts "[#{index}] #{train_type[:name]}"
    end
  end

  def gets_train_manufacturer
    maker_key = Train::MANUFACTURERS[gets_train_manufacturer_index]
    maker_key[:name]
  end

  def gets_train_manufacturer_index
    train_manufacturers
    puts 'Введите индекс производителя поезда:'
    gets_integer
  end

  def train_manufacturers
    Train::MANUFACTURERS.each_with_index do |maker, index|
      puts "[#{index}] #{maker[:name]}"
    end
  end

  def gets_integer
    input = gets.chomp.strip
    input.empty? || /\D/.match(input) ? 'Повторите ввод' : input.to_i
  end

  def gets_train_number
    puts 'Задайте номер поезда:'
    gets.chomp.strip.to_i
  end

  def gets_station_index
    print_stations
    puts 'Введите индекс станции'
    gets_integer
  end

  def gets_route_index
    puts 'Введите индекс маршрута'
    gets_integer
  end

  def gets_train_index
    print_trains
    puts 'Введите индекс нужного поезда'
    gets_integer
  end

  def print_trains_on_station(station)
    station.each_train do |_number, train|
      puts "#{train.to_s}"
      train.each_wagon { |wagon| puts "#{wagon.to_s}" }
      puts
    end
  end

  def create_cargo_wagon
    CargoWagon.new(gets_volume)
  end

  def gets_volume
    puts 'Введите объeм:'
    gets_wagon_attribute
  end

  def create_pass_wagon
    PassWagon.new(gets_number_of_seats)
  end

  def gets_number_of_seats
    puts 'Введите кол-во мест в вагоне:'
    gets_wagon_attribute
  end

  def gets_wagon_attribute
    input = gets.chomp.strip
    raise StandardError, 'Повторите ввод' if input.empty? || /\D/.match(input)

    input.to_i
  end

  def load_cargo_wagon(wagon)
    volume = gets_volume
    wagon.load(volume)
  end

  def unload_cargo_vagon(wagon)
    volume = gets_volume
    wagon.unload(volume)
  end

  def occupy_seats(wagon)
    wagon.use_seat
  end

  def leave_seat(wagon)
    wagon.leave_seat
  end

  # rubocop:disable Metrics/AbcSize
  def move_train(move_direction)
    raise StandardError, 'Список поездов пуст' if trains.empty?
    raise StandardError, 'Список маршрутов пуст' if routes.empty?

    train = gets_train
    raise StandardError, "Поезду #{train.number} не назначен  маршрут" if train.route.nil?

    puts "Поезд #{train.number} двигается по маршруту #{train.route.to_s}"
    puts "Текущая станция #{train.current_station.name}"
    train.public_send move_direction
    puts "Следующая станция #{train.current_station.name}"
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/ClassLength
end
