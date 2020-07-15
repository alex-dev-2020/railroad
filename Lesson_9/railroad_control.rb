# class Railroad

require_relative "pass_train"
require_relative "cargo_train"
require_relative "train"
require_relative "station"
require_relative "wagon"
require_relative "cargo_wagon"
require_relative "pass_wagon"
require_relative "route"

class RailroadControl
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
    puts "Выбран пункт:"
    gets.chomp
  end

  # test object generation
  def seed
    cargo_test_train = CargoTrain.new("123-45", "tesla")
    cargo_test_wagon = CargoWagon.new(100)
    cargo_test_train.add_wagon(cargo_test_wagon)
    @trains << cargo_test_train
    pass_test_train = PassTrain.new("543-21", "bosh")
    pass_test_wagon = PassWagon.new(45)
    pass_test_train.add_wagon(pass_test_wagon)
    @trains << pass_test_train
    test_station_1 = Station.new("test-station-1")
    @stations << test_station_1
    test_station_2 = Station.new("test-station-2")
    @stations << test_station_2
    test_station_3 = Station.new("test-station-3")
    @stations << test_station_3
    route_test = Route.new(test_station_1, test_station_2)
    @routes << route_test
    puts
    print_stations_only
    # puts
    print_routes
    print_route_stations(routes[0])
    # puts
    print_trains
    # puts
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
    raise StandardError, "Нет станций" if stations.empty?

    station = gets_station
    puts "Станция: #{station.name} (поездов: #{station.trains.length})"
    print_trains_on_station(station)
  end

  def print_trains_on_each_station
    raise StandardError, "Нет станций" if stations.empty?

    stations.each do |station|
      puts "#{station.name}"
      print_trains_on_station(station)
      puts
    end
  end

  def create_train
    type_index = gets_train_type_index
    maker_index = gets_train_manufacturer
    train_number = gets_train_number

    begin
      case Train::TYPES[type_index][:type]
      when "CargoTrain"
        train = CargoTrain.new(train_number, maker_index)
      when "PassTrain"
        train = PassTrain.new(train_number, maker_index)
      end
    rescue StandardError => e
      puts e
      retry
    end

    puts "Создан поезд #{train.to_s}"
    @trains << train
  end

  def print_trains
    puts "Существующие поезда:"
    trains.each_with_index { |train, index| puts "[#{index}] #{train}" }
  end

  def create_route
    raise StandardError, "Нужны минимум 2 созданные станции" if stations.length < 2

    first_station = gets_station { puts "Начальная станция:" }
    last_station = gets_station { puts "Конечная станция:" }

    @routes << Route.new(first_station, last_station)

    puts "Маршрут '#{first_station.name} -> #{last_station.name}' создан"
  end

  def print_routes
    puts "Существующие маршруты:"
    routes.each_with_index { |route, index| puts "[#{index}] #{route}" }
  end

  def print_routes_stations
    route = gets_route
    print_route_stations(route)
  end

  def print_route_stations(route)
    puts "Маршрут #{route.to_s} содержит следующие станции:"
    # puts "Станция: #{station.name} (поездов: #{station.trains})"
    route.stations.each_with_index do |station, index|
      puts "[#{index}] #{station.name}"
    end
  end

  def add_route_to_train
    if trains.empty?
      puts "Список поездов пуст"
      return
    elsif routes.empty?
      puts "Список маршрутов пуст"
      return
    else
      route = gets_route

      train = gets_train

      train.accept_route(route)

      puts "Mаршрут '#{route.stations.first.name}' -> '#{route.stations.last.name}' назначен поезду '#{train.number}'"
    end
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
        puts "Ошибка создания вагона"
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
      puts "У данного поезда нет вагонов"
      return
    else
      train.wagons.pop
    end

    puts "Вагон отцеплен от поезда №#{train.number}"
  end

  def print_trains
    puts "Существующие поезда:"
    trains.each_with_index do |train, index|
      puts "[#{index}] #{train.to_s} "
    end
  end

  def print_trains_wth_wagons
    puts "Существующие поезда c вагонами :"
    trains.each_with_index do |train, index|
      puts "[#{index}] #{train.to_s} "
      puts "Вагоны:"
      train.each_wagon do |wagon|
        puts wagon.to_s
      end
    end
  end

  private

  def gets_station_name
    puts "Введите название станции"
    gets.chomp.lstrip.rstrip
  end

  def gets_station
    yield if block_given?
    station_index = gets_station_index
    validate!(station_index, stations)
    stations[station_index]
  end

  def gets_route
    raise StandardError, "Список маршрутов пуст!" if routes.empty?
    print_routes
    route_index = gets_route_index
    validate!(route_index, routes)
    routes[route_index]
  end

  def gets_train
    raise StandardError, "Список поездов пуст!" if trains.empty?
    train_index = gets_train_index
    validate!(train_index, trains)
    trains[train_index]
  end

  def gets_train_type_index
    train_types
    puts "Введите индекс типа поезда:"
    gets_integer
  end

  def train_types
    Train::TYPES.each_with_index do |train_type, index|
      puts "[#{index}] #{train_type[:name]}"
    end
  end

  def gets_train_manufacturer
    train_manufacturers
    puts "Введите индекс производителя поезда:"
    gets_integer
  end

  def train_manufacturers
    Train::MANUFACTURERS.each_with_index do |maker, index|
      puts "[#{index}] #{maker[:name]}"
    end
  end

  def gets_integer
    input = gets.chomp.lstrip.rstrip
    return input.empty? || /\D/.match(input) ? "Повторите ввод" : input.to_i
  end

  def gets_train_number
    puts "Задайте номер поезда:"
    gets.chomp.lstrip.rstrip
  end

  def gets_station_index
    print_stations
    puts "Введите индекс станции"
    gets_integer
  end

  def gets_route_index
    puts "Введите индекс маршрута"
    gets_integer
  end

  def gets_train_index
    print_trains
    puts "Введите индекс нужного поезда"
    gets_integer
  end

  def print_trains_on_station(station)
    station.each_train do |number, train|
      puts "#{train.to_s}"
      train.each_wagon { |wagon| puts "#{wagon.to_s}" }
      puts
    end
  end

  def create_cargo_wagon
    CargoWagon.new(gets_volume)
  end

  def gets_volume
    puts "Введите объeм:"
    gets_wagon_attribute
  end

  def create_pass_wagon
    PassWagon.new(gets_number_of_seats)
  end

  def gets_number_of_seats
    puts "Введите кол-во мест в вагоне: "
    gets_wagon_attribute
  end

  def gets_wagon_attribute
    input = gets.chomp.lstrip.rstrip
    raise StandardError, "Повторите ввод" if input.empty? || /\D/.match(input)
    input.to_i
  end
end
