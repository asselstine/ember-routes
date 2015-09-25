module EmberRoutes
  class Route
    attr_accessor :name, :path, :children
    def initialize(name, opts = {})
      @name = name.to_s
      @path = opts.fetch(:path, name)
      @children = []
    end
    def route(*arguments, &block)
      p = Route.new(*arguments)
      self.children << p
      if block_given?
        p.instance_eval(&block)
      end
      p
    end
  end
end
