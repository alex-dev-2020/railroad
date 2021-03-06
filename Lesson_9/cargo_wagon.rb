# frozen_string_literal: true

require_relative 'wagon'
require_relative 'instance_counter'
require_relative 'valid'

class CargoWagon < Wagon
  attr_reader :total_volume

  def initialize(total_volume)
    raise StandardError, 'Объем при создании должен быть больше 0' if total_volume <= 0

    @total_volume = total_volume
    @number = generate_number
    @volume = 0
    register_instance
  end

  def load(volume)
    raise StandardError, 'Вагон полностью загружен' if self.volume + volume > total_volume

    self.volume += volume
  end

  def type
    :cargo
  end

  def unload(volume)
    raise StandardError, 'Объем не может быть меньше 0' if (self.volume - volume).negative?

    self.volume -= volume
  end

  def free_volume
    total_volume - self.volume
  end

  def occupied_volume
    self.volume
  end

  def to_s
    "Вагон №'#{number}'тип'#{type}'загружен'#{occupied_volume}'свободно'#{free_volume}'"
  end

  protected

  attr_accessor :volume
end
