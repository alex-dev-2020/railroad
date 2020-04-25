# class Railroad

class Railroad
  attr_reader :stations, :routes, :trains


  def initialize
    @stations = []
    @routes = []
    @trains = []
    @trains = []
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
    @trains << cargo_test_train
    pass_test_train = PassTrain.new('543-21', 'bosh')
    @trains << pass_test_train
    test_station_1 = Station.new('test-st-1')
    @stations << test_station_1
    test_station_2 = Station.new('test-station-2')
    @stations << test_station_2
    test_station_3 = Station.new('test-station-3')
    route_test = Route.new(test_station_1, test_station_2)
    @routes << route_test
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
    puts "Cоздана станция'#{station_name}'"
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
    "Создан поезд № #{number}, тип #{Train::TYPES[type_index][:name]}, производитель #{Train::MANUFACTURERS[maker_index][:name]}"
  end


  def create_route
    if self.stations.length < 2
      puts 'Количество существующих станций меньше 2'
      return

    else

      self.print_stations

      begin
        first_station_index = gets_first_station_index
        validate!(first_station_index, self.stations)
      rescue RuntimeError => e
        puts e
        retry
      end

      begin
        last_station_index = gets_last_station_index
        validate!(last_station_index, self.stations)
      rescue RuntimeError => e
        puts e
        retry
      end

      begin
        route = Route.new(self.stations[first_station_index], self.stations[last_station_index])
      rescue StandardError => e
        puts e
        return
      end

      self.routes << route

      puts "Маршрут '#{ self.stations[first_station_index].name} -> #{self.stations[last_station_index].name}'создан "
    end
  end

  def add_station_to_route
    if self.routes.empty?
      puts 'Список маршрутов пуст'
      return

    else

      self.print_routes

      begin
        route_index = gets_route_index
        validate!(route_index, self.routes)
      rescue StandardError => e
        puts e
        return
      end

      self.print_stations

      begin
        begin
          station_index = gets_station_index
          validate!(station_index, self.stations)
        rescue StandardError => e
          puts e
          return
        end
        self.routes[route_index].add_station(stations[station_index])
      rescue StandardError
        puts "Маршрут уже содержит данную  станцию:'#{stations[station_index].name}'"
        return
      end

      puts "Станция '#{stations[station_index].name}' добавлена в маршрут"

    end
  end


  def delete_station_from_route
    if self.routes.empty?
      puts 'Список маршрутов пуст'
      return

    else

      self.print_routes

      begin
        route_index = gets_route_index
        validate!(route_index, self.routes)
      rescue StandardError => e
        puts e
        return
      end

      self.print_stations

      begin
        begin
          station_index = gets_station_index
          validate!(station_index, self.stations)
        rescue StandardError => e
          puts e
          return
        end
        self.routes[route_index].delete_station(stations[station_index])
      rescue StandardError => e
        puts e
        return
      end

      puts "Станция '#{stations[station_index].name}' удалена из маршрута"

    end
  end


  def add_route_to_train
    if self.trains.empty?
      puts 'Список поездов пуст'
      return

    elsif self.routes.empty?
      puts 'Список маршрутов пуст'
      return
    else

      self.print_routes

      begin
        route_index = gets_route_index
        validate!(route_index, self.routes)
      rescue StandardError => e
        puts e
        return
      end

      self.print_trains

      begin
        train_index = gets_train_index
        validate!(train_index, self.trains)
      rescue StandardError => e
        puts e
        return
      end

      self.trains[train_index].accept_route(self.routes[route_index])
      "Mаршрут '#{self.routes[route_index].stations.first}' -> '#{self.routes[route_index].stations.last}' добавлен поезду '#{self.trains[train_index].number}'"

    end
  end

  def add_wagon
    puts 'Список существующих поездов:'
    self.print_trains
    begin
      train_index = gets_train_index
      validate!(train_index, self.trains)
    rescue StandardError => e
      puts e
      return
    end
    accepting_train = self.trains.at(train_index)
    accepting_train_class = self.trains.at(train_index).class
    if accepting_train_class == CargoTrain
      begin
        accepting_train.add_wagon(create_cargo_wagon)
      rescue StandardError => e
        puts e
        return
      end
    elsif accepting_train_class == PassTrain
      begin
        accepting_train.add_wagon(create_pass_wagon)
      rescue StandardError => e
        puts 'Ошибка создания вагона'
        puts e
        return
      end
    end
    print "Вагон добавлен к поезду №'#{accepting_train.number}'"
  end

  def detach_wagon
    puts 'Список существующих поездов:'
    self.print_trains
    begin
      train_index = gets_train_index
      validate!(train_index, self.trains)
    rescue StandardError => e
      puts e
      return
    end
    donor_train = self.trains.at(train_index)
    donor_train.wagons.pop
    print "Вагон отцеплен от поезда №'#{donor_train.number}'"
  end


  def move_train
    puts 'Список существующих поездов:'
    print_trains
    puts 'Введите номер нужного поезда'
    selected_train_index = gets.chomp.to_i - 1
    selected_train = self.trains.at(selected_train_index)
    puts 'Выбран поезд:'
    puts selected_train.number
    puts 'Поезду назначен маршрут:'
    puts "'#{selected_train.route.stations.first.name}'-> '#{selected_train.route.stations.last.name}'"
    puts 'Текущая станция:'
    puts selected_train.current_station.name
    puts 'Выберите направление движения:'
    puts '1-вперед, 2 - назад'
    selected_direction = gets.chomp.to_i
    if selected_direction == 1
      selected_train.move_forward
      puts 'Следующая станция'
      puts selected_train.next_station.name
    elsif selected_direction == 2
      selected_train.move_back
      puts 'Следующая станция'
      puts selected_train.previous_station.name
    end
  end

  def show_train_list
    self.stations.each.with_index(1) { |station, index| puts "#{index} #{station.name}" }
    puts 'Введите номер станции'
    selected_station_index = gets.chomp.to_i - 1
    selected_station = self.stations.at(selected_station_index)
    puts 'Выбрана станция:'
    puts selected_station.name
    puts 'Список поездов на станции:'
    print_trains_on_station(selected_station)
    # selected_station.trains.each.with_index(1) { |train, index| puts "'#{index}'поезд номер' #{train.number}'" }
  end

  def print_trains_on_station(station)
    puts "Станция: #{station.name} (поездов: #{station.trains.length})"
    station.each_train do |train|
      puts train.to_s
      # train.each_wagon { |wagon| puts wagon.to_s }
      puts
    end
  end

  def validate!(index, object)
    raise "Индекс не существует (#{index})" if !index.is_a?(Integer) || object[index].nil?
  end

  def print_stations
    puts 'Существующие станции:'
    self.stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
  end

  def print_routes
    puts 'Существующие маршруты:'
    self.routes.each_with_index { |route, index| puts "[#{index}] #{route}" }
  end

  def print_trains
    puts 'Существующие поезда:'
    self.trains.each_with_index { |train, index| puts "[#{index}] #{train}" }
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
    train.each_with_index { |wagon, index| puts "[#{index}] #{wagon}" }
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

end
