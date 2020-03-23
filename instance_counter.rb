module InstanceCounter


  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods


    def instances
      @instances
    end

    def instances=(value)
      @instances = value
    end
  end

  module InstanceMethods
    protected

    def register_instance
      instances = (self.class.instances.nil?) ? 0 : self.class.instances
      self.class.send :instances=, instances + 1
    end
  end
end