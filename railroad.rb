require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_wagon'
require_relative 'cargo_wagon'


class Railroad
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  # работа с текстовыми меню ()
  def selection(menu)
    menu.each { |key, value| puts "#{key} - #{value}" }
    puts 'Выбран пункт:'
    gets.chomp
  end



  def create_station
    puts 'Введите название станции'
    station_name = gets.chomp.to_s
    new_station = Station.new(station_name)
    @stations << new_station
  end

  def create_train
    puts 'Введите тип поезда'
    train_type = gets.chomp.to_s
    puts 'Введите номер поезда'
    train_name = gets.chomp.to_s
    if train_type == 'cargo'
      new_train = CargoTrain.new(train_name)
    else
      new_train = PassTrain.new(train_name)
    end
    @trains << new_train
  end

  # список существующих поездов
  def trains_list
    self.trains.each.with_index(1) { |index, train| puts "#{train} #{index}" }
  end

  # список существующих маршрутов
  def route_list
    self.routes.each.with_index(1) { |index, route| puts "#{route} #{index}" }
  end

  def create_route
    puts 'Введите название первой станции маршрута'
    first_station = gets.chomp.to_s
    puts 'Введите название последней станции маршрута'
    last_station = gets.chomp.to_s
    new_route = Route.new(first_station, last_station)
    self.routes << new_route
    puts 'Создан маршрут:'
    print new_route.stations
  end

  def accept_route
    trains_list
    puts 'Введите номер нужного поезда'
    accepting_train_index = gets.chomp.to_i - 1
    accepting_train = self.trains.at(accepting_train_index)
    puts 'Список текущих маршрутов:'
    route_list
    puts 'Введите номер требуемого маршрута'
    accepted_route_index = gets.chomp.to_i - 1
    accepted_route = self.routes.at(accepted_route_index)
    accepting_train.accept_route(accepted_route)
  end

  def add_wagon
    puts 'Список существующих поездов:'
    trains_list
    puts 'Введите номер нужного поезда'
    accepting_train_index = gets.chomp.to_i - 1
    accepting_train = self.trains.at(accepting_train_index)
    accepting_train_class = self.trains.at(accepting_train_index).class
    if accepting_train_class == CargoTrain
      wagon = CargoWagon.new
      accepting_train.add_wagon(wagon)
    elsif accepting_train_class == PassTrain
      wagon = PassWagon.new
      accepting_train.add_wagon(wagon)
    end
    print accepting_train.wagons
  end

  def detach_wagon
    puts 'Список существующих поездов:'
    trains_list
    puts 'Введите номер нужного поезда'
    donor_train_index = gets.chomp.to_i - 1
    donor_train = self.trains.at(donor_train_index)
    donor_train_class = self.trains.at(donor_train_index).class
    puts donor_train_class
    print donor_train.wagons
    donor_train.wagons.pop
    puts
    puts 'Вагон отцеплен'
    print donor_train.wagons
  end


  def move_train
    puts 'Список существующих поездов:'
    trains_list
    puts 'Введите номер нужного поезда'
    selected_train_index = gets.chomp.to_i - 1
    selected_train = self.trains.at(selected_train_index)
    puts 'Выбран поезд:'
    puts selected_train
    puts 'Список текущих маршрутов:'
    route_list
    puts 'Введите номер требуемого маршрута'
    accepted_route_index = gets.chomp.to_i - 1
    accepted_route = self.routes.at(accepted_route_index)
    puts accepted_route
    selected_train.accept_route(accepted_route)
    puts 'Текущая станция:'
    puts selected_train.current_station.name
    puts 'Выберите направление движения:'
    puts '1-вперед, 2 - назад'
    selected_direction = gets.chomp.to_i
    if selected_direction == 1
      selected_train.move_forward
    elsif selected_direction == 2
      selected_train.move_back
    end
    puts 'Новая станация'
    puts selected_train.current_station.name
  end

  def show_train_list
    self.stations.each.with_index(1) { |station, index| puts "#{index } #{station.name}" }
    puts 'Введите номер станции'
    selected_station_index = gets.chomp.to_i - 1
    selected_station = self.stations.at(selected_station_index)
    puts 'Выбрана станция:'
    puts selected_station.name
    puts 'Список поездов на станции:'
    puts selected_station.trains
  end

end