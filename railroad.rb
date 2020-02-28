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


# метод для генерации тестовых объектов
  def seed
    cargo_test_train = CargoTrain.new('cargo_test')
    @trains << cargo_test_train
    pass_test_train = PassTrain.new('pass_test')
    @trains << pass_test_train
    test_station_1 = Station.new('test_st_1')
    @stations << test_station_1
    test_station_2 = Station.new('test_station_2')
    @stations << test_station_2
    test_station_3 = Station.new('test_station_3')
    route_test = Route.new(test_station_1, test_station_2)
    @routes << route_test
  end

  if user_choice == '1'
    puts 'Введите название станции'
    station_name = gets.chomp.to_s
    new_station = Station.new(station_name)
    my_railroad.stations << new_station
  elsif user_choice == '2'
    puts 'Введите тип поезда'
    train_type = gets.chomp.to_s
    puts 'Введите номер поезда'
    train_name = gets.chomp.to_s
    if train_type == 'cargo'
      new_train = CargoTrain.new(train_name)
    else
      new_train = PassTrain.new(train_name)
    end
    my_railroad.trains << new_train
  elsif user_choice == '3'
    puts 'Введите название первой станции маршрута'
    first_station = gets.chomp.to_s
    puts 'Введите название последней станции маршрута'
    last_station = gets.chomp.to_s
    new_route = Route.new(first_station, last_station)
    my_railroad.routes << new_route
  elsif user_choice == '4'
    #n 4.Назначить маршрут поезду
    # Нужно вывести список текущих поездов
    puts 'Список существующих поездов:'
    my_railroad.trains.each.with_index(1) { |index, train| puts "#{train} #{index}" }
    puts 'Введите номер нужного поезда'
    accepting_train_index = gets.chomp.to_i - 1
    accepting_train = my_railroad.trains.at(accepting_train_index)
    #  only for test purpose
    puts accepting_train
    #  нужно вывести список текущих маршрутов
    puts 'Список текущих маршрутов:'
    my_railroad.routes.each.with_index(1) { |index, route| puts "#{route} #{index}" }
    puts 'Введите номер требуемого маршрута'
    accepted_route_index = gets.chomp.to_i - 1
    accepted_route = my_railroad.routes.at(accepted_route_index)
    #  only for test purpose
    puts accepted_route
    accepting_train.accept_route(accepted_route)
    #  only for test purpose
    puts accepting_train.current_station.name
  elsif user_choice == '5'
    #n 5.Добавить  вагоны к поезду
    # Нужно вывести список текущих поездов
    puts 'Список существующих поездов:'
    my_railroad.trains.each.with_index(1) { |index, train| puts "#{train} #{index}" }
    puts 'Введите номер нужного поезда'
    accepting_train_index = gets.chomp.to_i - 1
    # определяем объект выбранный пользователем
    accepting_train = my_railroad.trains.at(accepting_train_index)
    # определяем класс объекта выбранного пользователем
    accepting_train_class = my_railroad.trains.at(accepting_train_index).class
    # ветвление
    if accepting_train_class == CargoTrain
      wagon = CargoWagon.new
      accepting_train.add_wagon(wagon)
    elsif accepting_train_class == PassTrain
      wagon = PassWagon.new
      accepting_train.add_wagon(wagon)
    end
    # only for test purpose
    print accepting_train.wagons
  elsif user_choice == '6'
    #п 6.Отцепить вагоны от поезда
    # Нужно вывести список текущих поездов
    puts 'Список существующих поездов:'
    my_railroad.trains.each.with_index(1) { |index, train| puts "#{train} #{index}" }
    puts "\nВведите номер нужного поезда "
    donor_train_index = gets.chomp.to_i - 1
    # определяем объект выбранный пользователем
    donor_train = my_railroad.trains.at(donor_train_index)
    # определяем класс объекта выбранного пользователем
    donor_train_class = my_railroad.trains.at(donor_train_index).class
    puts donor_train_class
    # Нужно вывести список вагонов выбранного поезда
    print donor_train.wagons
    donor_train.wagons.pop
    # just for test
    puts
    puts 'Вагон отцеплен'
    print donor_train.wagons
    # 7.Переместить поезд по маршруту вперед и назад
  elsif user_choice == '7'
    # Нужно вывести список текущих поездов
    puts 'Список существующих поездов:'
    my_railroad.trains.each.with_index(1) { |index, train| puts "#{train} #{index}" }
    # определяем объект выбранный пользователем
    puts 'Введите номер нужного поезда'
    selected_train_index = gets.chomp.to_i - 1
    selected_train = my_railroad.trains.at(selected_train_index)
    # just for test
    puts 'Выбран поезд:'
    puts selected_train
    # по хорошему - надо бы маршрут назначить для начала
    #  нужно вывести список текущих маршрутов
    puts 'Список текущих маршрутов:'
    my_railroad.routes.each.with_index(1) { |index, route| puts "#{route} #{index}" }
    puts 'Введите номер требуемого маршрута'
    accepted_route_index = gets.chomp.to_i - 1
    accepted_route = my_railroad.routes.at(accepted_route_index)
    #  only for test purpose - назначаем маршрут выбранному поезду
    puts accepted_route
    selected_train.accept_route(accepted_route)
    #  only for test purpose - убеждаемся что поезд стоит на первой станции маршрута
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
    puts selected_train.current_station.namessss
    # 8.Просмотреть список станций и список поездов на станции
  elsif user_choice == '8'
    # Вывод списка станций  - построчно
    my_railroad.stations.each.with_index(1) { |station, index| puts "#{index } #{station.name}" }
    #  Нужно теперь реализовать выбор станции
    puts 'Введите номер станции'
    selected_station_index = gets.chomp.to_i - 1
    selected_station = my_railroad.stations.at(selected_station_index)
    puts 'Выбрана станция:'
    puts selected_station.name
    puts 'Список поездов на станции:'
    puts selected_station.trains
  end

end