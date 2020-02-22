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
    @stations = ['just for test']
    @routes = ['just for fun']
    @trains = ['just for luls']
  end
end
