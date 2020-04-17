require_relative 'wagon'
# lines below included only for test purpose 
require_relative 'instance_counter'
require_relative 'valid'

class CargoWagon < Wagon
  attr_reader :total_volume
  include InstanceCounter
  include Valid


  def initialize(total_volume)
    raise StandardError, 'Объем при создании должен быть больше 0' if total_volume <= 0
    @total_volume = total_volume
    @number = generate_number
    @volume = 0
    register_instance
  end

  def load(volume)
    raise StandardError, 'Вагон уже имеет максимальную загрузку' if self.volume + volume > total_volume
    self.volume += volume
  end

  def type
    :cargo
  end

  def unload(volume)
    raise StandardError, 'Нельзя выгрузить больше, чем имеется в вагоне' if self.volume - volume < 0
    self.volume -= volume
  end

  def free_volume
    total_volume - self.volume
  end

  def occupied_volume
    self.volume
  end

  def to_s
    "Вагон №'#{number}'тип'#{self.type}'загружен'#{occupied_volume}'свободно'#{free_volume}'"
  end

  protected

  attr_accessor :volume

end






