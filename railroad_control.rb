# class Railroad

class Railroad
  attr_reader :stations, :routes, :trains


  def initialize
    @stations = []
    @routes = []
    @trains = []
    @trains = []
  end

  # def seed
  #   cargo_test_train = CargoTrain.new('cargo_test', '12345', 'tesla')
  #   @trains << cargo_test_train
  #   pass_test_train = PassTrain.new('pass_test', '54321', 'bosh')
  #   @trains << pass_test_train
  #   test_station_1 = Station.new('test_st_1')
  #   @stations << test_station_1
  #   test_station_2 = Station.new('test_station_2')
  #   @stations << test_station_2
  #   test_station_3 = Station.new('test_station_3')
  #   route_test = Route.new(test_station_1, test_station_2)
  #   @routes << route_test
  # end

  # работа с текстовыми меню (возможно тоже следует вынести в отдельный файл)
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

    # puts error
    # else
    # just fot test
    @trains << train
    puts "Создан поезд № #{number}, тип #{Train::TYPES[type_index][:name]}, производитель #{Train::MANUFACTURERS[maker_index][:name]}"
    puts train.inspect
  end


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


  def validate!(index, object)
    raise "Индекс не существует (#{index})" if !index.is_a?(Integer) || object[index].nil?
  end

  private

  def gets_integer
    input = gets.chomp.lstrip.rstrip
    return (input.empty? || /\D/.match(input)) ? input : input.to_i
  end

  def gets_train_number
    print "Задайте номер поезда:"
    gets.chomp.lstrip.rstrip
  end

  def gets_train_type_index
    print "Введите индекс типа поезда:"
    gets_integer
  end

  def gets_train_maker_index
    print "Введите индекс производителя поезда:"
    gets_integer
  end
end