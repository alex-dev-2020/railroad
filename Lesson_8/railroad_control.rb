# frozen_string_literal: true

# class Railroad

class Railroad
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
    # just for test
    puts "Создана станция'#{station_name}'"
  end

  def create_train
    Train::TYPES.each_with_index do |train_type, index|
      puts "[#{index}] #{train_type[:name]}"
    end

    begin
      type_index = gets_train_type_index
      validate!(type_index, Train::TYPES)
    rescue RuntimeError => e
      puts e
      retry
    end

    Train::MANUFACTURERS.each_with_index do |maker, index|
      puts "[#{index}] #{maker[:name]}"
    end

    begin
      maker_index = gets_train_maker_index
      validate!(maker_index, Train::MANUFACTURERS)
    rescue RuntimeError => e
      puts e
      retry
    end

    case Train::MANUFACTURERS[maker_index][:name]
    when 'Siemens'
      made_by = 'Siemens'
    when 'Bosh'
      made_by = 'Bosh'
    when 'Tesla'
      made_by = 'Tesla'
    end

    begin
      number = gets_train_number
      case Train::TYPES[type_index][:type]
      when 'CargoTrain'
        train = CargoTrain.new(number, made_by)
      when 'PassTrain'
        train = PassTrain.new(number, made_by)
      end
    rescue StandardError => e
      puts e
      retry
    end
    @trains << train
  end

  def create_route
    if stations.length < 2
      puts 'Количество существующих станций меньше 2'
      return
    else
      print_stations

      begin
        first_station_index = gets_first_station_index
        validate!(first_station_index, stations)
      rescue RuntimeError => e
        puts e
        retry
      end

      begin
        last_station_index = gets_last_station_index
        validate!(last_station_index, stations)
      rescue RuntimeError => e
        puts e
        retry
      end

      begin
        route = Route.new(stations[first_station_index], stations[last_station_index])
      rescue StandardError => e
        puts e
        return
      end

      routes << route

      puts "Маршрут '#{ stations[first_station_index].name} -> #{stations[last_station_index].name}'создан "
    end
  end

  def add_station_to_route
    if routes.empty?
      puts 'Список маршрутов пуст'
      return

    else

      print_routes

      begin
        route_index = gets_route_index
        validate!(route_index, routes)
      rescue StandardError => e
        puts e
        return
      end

      print_stations

      begin
        begin
          station_index = gets_station_index
          validate!(station_index, stations)
        rescue StandardError => e
          puts e
          return
        end
        routes[route_index].add_station(stations[station_index])
      rescue StandardError
        puts "Маршрут уже содержит данную  станцию:'#{stations[station_index].name}'"
        return
      end

      puts "Станция '#{stations[station_index].name}' добавлена в маршрут"

    end
  end

  def delete_station_from_route
    if routes.empty?
      puts 'Список маршрутов пуст'
      return

    else

      print_routes

      begin
        route_index = gets_route_index
        validate!(route_index, routes)
      rescue StandardError => e
        puts e
        return
      end

      print_stations

      begin
        begin
          station_index = gets_station_index
          validate!(station_index, stations)
        rescue StandardError => e
          puts e
          return
        end
        routes[route_index].delete_station(stations[station_index])
      rescue StandardError => e
        puts e
        return
      end

      puts "Станция '#{stations[station_index].name}' удалена из маршрута"

    end
  end

  def add_route_to_train
    if trains.empty?
      puts 'Список поездов пуст'
      return

    elsif routes.empty?
      puts 'Список маршрутов пуст'
      return
    else
      print_routes

      begin
        route_index = gets_route_index
        validate!(route_index, routes)
      rescue StandardError => e
        puts e
        return
      end

      print_trains

      begin
        train_index = gets_train_index
        validate!(train_index, trains)
      rescue StandardError => e
        puts e
        return
      end
      trains[train_index].accept_route(routes[route_index])
      puts "Mаршрут '#{routes[route_index].stations.first.name}' -> '#{routes[route_index].stations.last.name}' назначен поезду '#{trains[train_index].number}'"
    end
  end

  def add_wagon
    puts 'Список существующих поездов c вагонами:'
    print_trains_wth_wagons
    begin
      train_index = gets_train_index
      validate!(train_index, trains)
    rescue StandardError => e
      puts e
      return
    end
    accepting_train = trains.at(train_index)
    accepting_train_class = trains.at(train_index).class
    if accepting_train_class == CargoTrain
      begin
        wagon = create_cargo_wagon
      rescue StandardError => e
        puts e
        return
      end
    elsif accepting_train_class == PassTrain
      begin
        wagon = create_pass_wagon
      rescue StandardError => e
        puts 'Ошибка создания вагона'
        puts e
        return
      end
    end
    accepting_train.add_wagon(wagon)
    puts "Вагон № #{wagon.number} тип #{wagon.class} добавлен к поезду №'#{accepting_train.number}'"
  end

  def load_wagon
    puts 'Список существующих поездов с вагонами:'
    print_trains_wth_wagons
    begin
      train_index = gets_train_index
      validate!(train_index, trains)
    rescue StandardError => e
      puts e
      return
    end

    operational_train = trains.at(train_index)
    operational_wagon = gets_wagon(operational_train)

    if operational_wagon.class == CargoWagon
      begin
        load_cargo_wagon(operational_wagon)
      rescue StandardError => e
        puts e
        return
      end
    else
      begin
        occupy_seats(operational_wagon)
      rescue StandardError => e
        puts e
        return
      end
    end
    puts "#{operational_wagon.to_s}"
  end

  def unload_wagon
    puts 'Список существующих поездов с вагонами:'
    print_trains_wth_wagons
    begin
      train_index = gets_train_index
      validate!(train_index, trains)
    rescue StandardError => e
      puts e
      return
    end
    operational_train = trains.at(train_index)
    operational_wagon = gets_wagon(operational_train)

    if operational_wagon.class == CargoWagon
      begin
        unload_cargo_vagon(operational_wagon)
      rescue StandardError => e
        puts e
        return
      end
    elsif operational_wagon.class == PassWagon
      begin
        leave_seat(operational_wagon)
      rescue StandardError => e
        puts e
        return
      end
    else
      puts "Вагон неизвестного типа"
    end
    puts "#{operational_wagon.to_s}"
  end

  def detach_wagon
    puts 'Список существующих поездов с вагонами:'
    print_trains_wth_wagons
    begin
      train_index = gets_train_index
      validate!(train_index, trains)
    rescue StandardError => e
      puts e
      return
    end
    donor_train = trains.at(train_index)
    if donor_train.wagons.empty?
      puts "У данного поезда нет вагонов"
      return
    else
      donor_train.wagons.pop
    end

    print "Вагон отцеплен от поезда №'#{donor_train.number}'"
  end

  def move_train
    puts 'Список существующих поездов:'
    print_trains
    puts 'Введите индекс нужного поезда'
    selected_train_index = gets.chomp.to_i
    selected_train = trains.at(selected_train_index)
    puts 'Выбран поезд:'
    puts selected_train.number
    if selected_train.route.nil?
      puts 'Поезду не назначено ни одного маршрута'
      return
    else
      puts 'Поезду назначен маршрут:'
      puts "'#{selected_train.route.stations.first.name}'-> '#{selected_train.route.stations.last.name}'"
      puts 'Текущая станция:'
      puts selected_train.current_station.name
      puts 'Выберите направление движения:'
      puts '1-вперед, 2 - назад'
      selected_direction = gets.chomp.to_i
      if selected_direction == 1
        begin
          selected_train.move_forward
        rescue StandardError => e
          puts e
          return
        end
        puts 'Следующая станция'
        puts selected_train.current_station.name
      elsif selected_direction == 2
        begin
          selected_train.move_back
        rescue StandardError => e
          puts e
          return
        end
        puts 'Следующая станция'
        puts selected_train.current_station.name
      end
    end
  end

  def show_train_list
    stations.each.with_index(1) { |station, index| puts "#{index} #{station.name}" }
    puts 'Введите номер станции'
    selected_station_index = gets.chomp.to_i - 1
    selected_station = stations.at(selected_station_index)
    puts 'Выбрана станция:'
    puts selected_station.name
    puts 'Список поездов на станции:'
    print_trains_on_station(selected_station)
  end

  def print_trains_on_station(station)
    puts "Станция: #{station.name} (поездов: #{station.trains.length})"
    # puts "Станция: #{station.name} (поездов: #{station.trains})"
    station.each_train do |number, train|
      puts train.to_s
      puts "Вагоны:"
      train.each_wagon do |wagon|
        puts wagon.to_s
      end
    end
  end

  def validate!(index, object)
    raise "Индекс не существует (#{index})" if !index.is_a?(Integer) || object[index].nil?
  end

  def print_stations
    puts 'Существующие станции:'
    stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
  end

  def print_routes
    puts 'Существующие маршруты:'
    routes.each_with_index { |route, index| puts "[#{index}] #{route}" }
  end

  def print_trains
    puts 'Существующие поезда:'
    trains.each_with_index { |train, index| puts "#{index} #{train.to_s} " }
  end

  def print_trains_wth_wagons
    puts 'Существующие поезда и вагоны :'
    trains.each_with_index do |train, index|
      puts "#{index} #{train.to_s} "
      puts "Вагоны:"
      train.each_wagon do |wagon|
        puts wagon.to_s
      end
    end
  end

  private

  def gets_station_name
    puts 'Введите название станции'
    gets.chomp.lstrip.rstrip
  end

  def gets_integer
    input = gets.chomp.lstrip.rstrip
    return (input.empty? || /\D/.match(input)) ? "Повторите ввод" : input.to_i
  end

  def gets_wagon_attribute
    input = gets.chomp.lstrip.rstrip
    raise StandardError, "Повторите ввод" if input.empty? || /\D/.match(input)

    input.to_i
  end

  def gets_train_number
    puts "Задайте номер поезда:"
    gets.chomp.lstrip.rstrip
  end

  def gets_train_type_index
    puts "Введите индекс типа поезда:"
    gets_integer
  end

  def gets_train_maker_index
    puts "Введите индекс производителя поезда:"
    gets_integer
  end

  def gets_station_index
    puts 'Введите индекс станции'
    gets_integer
  end

  def gets_first_station_index
    puts 'Введите индекс первой станции маршрута'
    gets_integer
  end

  def gets_last_station_index
    puts 'Введите индекс последней станции маршрута'
    gets_integer
  end

  def gets_route_index
    puts 'Введите индекс маршрута'
    gets_integer
  end

  def gets_train_index
    puts 'Введите индекс нужного поезда'
    gets_integer
  end

  def gets_wagon(train)
    print_wagons(train)
    puts 'Введите индекс вагона'
    wagon_index = gets_integer
    validate!(wagon_index, train.wagons)
    train.wagons[wagon_index]
  end

  def print_wagons(train)
    train.wagons.each_with_index { |wagon, index| puts "[#{index}] #{wagon.to_s}" }
  end

  def gets_number_of_seats
    puts 'Введите кол-во мест в вагоне: '
    gets_wagon_attribute
  end

  def gets_volume
    puts 'Введите объeм:'
    gets_wagon_attribute
  end

  def create_cargo_wagon
    CargoWagon.new(gets_volume)
  end

  def create_pass_wagon
    PassWagon.new(gets_number_of_seats)
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
end
