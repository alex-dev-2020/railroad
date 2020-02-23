class PassTrain < Train


  def add_wagon(wagon)
    @wagons << wagon if @speed == 0
  end


# нужно реализовывать проверку (вызов  списка вагонов у выбранного поезда)
  def detach_wagon(wagon)
    if @wagons.length > 0 && @speed == 0
      @wagons.delete(wagon)
    else
      puts 'Конечные точки маршрута удалить нельзя!'
    end
  end
end