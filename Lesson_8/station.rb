# require_relative 'valid'
# require_relative 'instance_counter'

class Station
  attr_reader :name, :trains
  include InstanceCounter
  include Valid
  @@list = []
  RGXP_STATION_NAME_FORMAT = /^[a-zа-я][a-zа-я]{1,30}([ \-][a-zа-я]{1,30})?([ \-][a-zа-я]{1,30})?([ \-][\d]{1,4})?$/i

  def initialize(name)
    @name = name
    @trains = {}
    validate!
    @@list << self
    register_instance
  end

  def validate!
    raise StandardError, "Неправильный формат названия станции (#{self.name})" if self.name !~ RGXP_STATION_NAME_FORMAT
  end

  def each_train(&block)
    @trains.each { |train| block.call(train) }  if block_given?
  end


  def self.all
    @@list
  end

  def train_in(train)
    @trains[train.number] = train
      # @trains << train
  end

  def trains_by_type(train_type)
    @trains.select { |train| train.type == train_type }
  end

  def train_out(train)
    @trains.delete(train)
  end
end