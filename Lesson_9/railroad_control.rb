# class Railroad

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
    puts 'Выбран пункт:'
    gets.chomp
  end

  # test object generation
  def seed
    cargo_test_train = CargoTrain.new('123-45', 'tesla')
    cargo_test_wagon = CargoWagon.new(100)
    cargo_test_train.add_wagon(cargo_test_wagon)
    @trains << cargo_test_train
    pass_test_train = PassTrain.new('543-21', 'bosh')
    pass_test_wagon = PassWagon.new(45)
    pass_test_train.add_wagon(pass_test_wagon)
    @trains << pass_test_train
    test_station_1 = Station.new('test-station-1')
    @stations << test_station_1
    test_station_2 = Station.new('test-station-2')
    @stations << test_station_2
    test_station_3 = Station.new('test-station-3')
    @stations << test_station_3
    route_test = Route.new(test_station_1, test_station_2)
    @routes << route_test
    puts
    print_stations
    puts
    print_routes
    print_route_stations(routes[0])
    puts
    print_trains
    puts
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
    puts "Создана станция'#{station_name}'"
  end
  
    def create_train
  
  gets_train_type
  gets_train_manufacturer
  
  begin
      number = gets_train_number
      case Train::TYPES[type_index][:type]
      when 'CargoTrain'
        train = CargoTrain.new(number, maker)
      when 'PassTrain'
        train = PassTrain.new(number, maker)
      end
    rescue StandardError => e
      puts e
      retry
    end
    @trains << train
  end
  
  
  private
  
  def gets_station_name
    puts 'Введите название станции'
    gets.chomp.lstrip.rstrip
  end

end
