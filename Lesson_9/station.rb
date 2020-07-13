# class Station

class Station
  attr_reader :name, :trains
  # include InstanceCounter
  # include Valid
  @@stations = []
  RGXP_STATION_NAME_FORMAT = /^[a-zа-я][a-zа-я]{1,30}([ \-][a-zа-я]{1,30})?([ \-][a-zа-я]{1,30})?([ \-][\d]{1,4})?$/i

  def initialize(name)
    @name = name
    @trains = {}
    validate!
    # register_instance
  end

  def validate!
    raise StandardError, "Неправильный формат названия станции (#{name})" if name !~ RGXP_STATION_NAME_FORMAT
  end

  def each_train
    trains.each { |train| yield(train) } if block_given?
  end

  def self.all
    @@list
  end

  def train_in(train)
    @trains[train.number] = train
  end

  def trains_by_type(train_type)
    @trains.select { |train| train.type == train_type }
  end

  def train_out(train)
    trains.delete(train)
  end

  # def to_s
  #   self.name
  # end
end
