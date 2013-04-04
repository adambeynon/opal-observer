module AttrObserver

  def add_observer name, &handler
    unless observers = @_attr_observers
      observers = @_attr_observers = {}
      @_attr_old_values = {}
    end

    unless handlers = observers[name]
      handlers = observers[name] = []
      @_attr_old_values[name] = __send__ name if respond_to? name

      if respond_to? "#{name}="
        define_singleton_method "#{name}=" do |val|
          super(val).tap { attr_did_change name }
        end
      end
    end

    handlers << handler

    handler
  end

  def remove_observer name, handler
    return unless @_attr_observers

    if handlers = @_attr_observers[name]
      handlers.delete handler
    end
  end

  def attr_did_change name
    old = @_attr_old_values[name]
    new = __send__ name if respond_to? name
    @_attr_observers[name].each { |h| h.call new, old }
    @_attr_old_values[name] = new
  end
end
