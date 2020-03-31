require_relative 'made_by'

class Wagon
  attr_reader :type
  include MadeBy
end
