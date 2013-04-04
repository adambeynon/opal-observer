module AttrObserver

  def add_observer name, &handler

    observers = (@_attr_observers ||= {})

    unless handlers = observers[name]
      handlers = observers[name] = []
      old_val = __send__ name if respond_to? name

      if respond_to? "#{name}="
        define_singleton_method "#{name}=" do |val|
          result = super val
          handlers.each { |h| h.call val, old_val }
          old_val = val
          result
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
end
