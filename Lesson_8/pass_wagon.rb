class PassWagon < Wagon
  attr_reader :number_of_seats
  include InstanceCounter
  include Valid
  
  def initialize(number_of_seats)
    raise StandardError, 'Кол-во мест должно быть целое число' unless number_of_seats.is_a?(Integer)
    raise StandardError, 'Кол-во мест должно быть больше 0' if number_of_seats <= 0
    @number_of_seats = number_of_seats
    @number = generate_number
    validate!
    register_instance
    self.seats = []
  end

  def type
    :pass
  end
  
  def busy_seat
    raise StandardError, 'Нет свободных мест' if number_of_busy_seats >= number_of_seats
    seats << 1
  end
  
  def number_of_busy_seats
    seats.length
  end
  
  def free_seat
    raise StandardError, 'Все места свободны' if number_of_free_seats == number_of_seats
    seats.pop
  end
  
  def number_of_free_seats
    number_of_seats - number_of_busy_seats
  end
  
end