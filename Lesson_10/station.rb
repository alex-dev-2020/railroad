# frozen_string_literal: true

# class Station

class Station
  attr_reader :name, :trains
  include InstanceCounter
  # include Valid
  include Validation
  @@stations = []
  # rubocop:disable Layout/LineLength
  NAME_FORMAT = /^[a-zа-я]{1,30}([ \-][a-zа-я]{1,30})?([ \-][a-zа-я]{1,30})?([ \-][\d]{1,4})?$/i.freeze
  # rubocop:enable Layout/LineLength

  validate :name, :type, String
  validate :name, :format, NAME_FORMAT, message: 'Неверный формат названия станции'

  def initialize(name)
    @name = name
    @trains = {}
    validate!
    register_instance
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

  def train_out(train)
    trains.delete(train)
  end

  def trains_by_type(train_type)
    @trains.select { |train| train.type == train_type }
  end

  def trains_count
    trains.length
  end

  def to_s
    name
  end
end
