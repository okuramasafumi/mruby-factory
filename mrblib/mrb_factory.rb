module Factory
  # Toplevel DSLs
  class << self
    def define(&block)
      Definer.new(&block)
    end

    def create(name, *traits, **options)
      Registry.find_factory(name).create(*traits, **options)
    end

    def generate(name)
      Registry.find_sequence(name).next
    end
  end

  module Registry
    @factories = {}
    @sequences = {}

    module_function def register_factory(name, builder)
      @factories[name] = builder
    end

    module_function def register_sequence(name, sequence)
      @sequences[name] = sequence
    end

    module_function def find_factory(name)
      @factories[name]
    end

    module_function def find_sequence(name)
      @sequences[name]
    end
  end

  class Sequence
    def initialize(initial = 0, &block)
      @block = block
      @i = initial
    end

    def next
      result = @block.call(@i)
      @i += 1
      result
    end
  end

  class Definer
    def initialize(&block)
      instance_eval(&block)
    end

    def sequence(name, initial = 0, &block)
      Registry.register_sequence(name, Sequence.new(initial, &block))
    end

    def factory(name, class_name: nil, &block)
      class_name ||= name.to_s.capitalize # TODO; Use ActiveSupport classify if possible
      Registry.register_factory(name, Builder.new(name, class_name, &block))
    end

    def generate(name)
      Registry.find_sequence(name).next
    end
  end

  class Builder
    def initialize(name, class_name, &block)
      @name = name
      @class_name = class_name
      @instance = Object.const_get(@class_name).new
      @block = block
      @sequences = {}
      @traits = {}
      @after_create_callbacks = []
    end

    def create(*traits, **options)
      instance_eval(&@block)
      apply_traits(*traits)
      apply_options(**options)
      @after_create_callbacks.each {|callback| callback.call(@instance) }
      @instance
    end

    private

    def factory(name, class_name: nil, &block)
      class_name ||= @instance.class.name
      Registry.register_factory(name, Builder.new(name, class_name, &block))
    end

    def trait(name, &block)
      @traits[name] = block
    end

    def sequence(name, initial = 0, &block)
      sequence = @sequences.fetch(name) do
        sequence = Sequence.new(initial, &block)
        @sequences[name] = sequence
      end
      @instance.send("#{name}=", sequence.next)
    end

    def generate(name)
      sequence = @sequences.fetch(name) { Registry.find_sequence(name) }
      raise "No sequence found with #{name}" unless sequence

      sequence.next
    end

    def method_missing(meth, *args, &blk)
      if @instance.respond_to?("#{meth}=")
        @instance.send("#{meth}=", blk.call)
      elsif @sequences[meth]
        @sequences[name].next
      else
        super
      end
    end

    def apply_options(**options)
      options.each do |k, v|
        @instance.send("#{k}=", v)
      end
    end

    def apply_traits(*names)
      names.each do |name|
        instance_eval(&@traits[name])
      end
    end

    def after_create(&block)
      @after_create_callbacks << block
    end
  end
end
