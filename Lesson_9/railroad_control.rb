# class Railroad

require_relative "pass_train"
require_relative "cargo_train"
require_relative "train"
require_relative "station"

class RailroadControl
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
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
    # cargo_test_wagon = CargoWagon.new(100)
    # cargo_test_train.add_wagon(cargo_test_wagon)
    @trains << cargo_test_train
    pass_test_train = PassTrain.new("543-21", "bosh")
    # pass_test_wagon = PassWagon.new(45)
    # pass_test_train.add_wagon(pass_test_wagon)
    @trains << pass_test_train
    test_station_1 = Station.new("test-station-1")
    @stations << test_station_1
    test_station_2 = Station.new("test-station-2")
    @stations << test_station_2
    test_station_3 = Station.new("test-station-3")
    @stations << test_station_3
    # route_test = Route.new(test_station_1, test_station_2)
    # @routes << route_test
    # puts
    print_stations_only
    # puts
    # print_routes
    # print_route_stations(routes[0])
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

  # def clear_screen
  #   print "\e[2J\e[f"
  # end

  private

  def gets_station_name
    puts "Введите название станции"
    gets.chomp.lstrip.rstrip
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
end
