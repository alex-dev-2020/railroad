require_relative 'train'

class CargoTrain < Train

  def type
    :cargo
  end
  
  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(CargoWagon)
  end
  
end
