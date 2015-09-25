module EmberRoutes
  class Generator

    def self.args_to_hash(*args)
      parameters = {}
      if args.any?
        if args.is_a?(Array)
          parameters = args.reduce({}) { |carry, elem| carry.merge(elem) }
        else
          parameters = args
        end
      end
      parameters
    end

    def self.format_path(path, path_params, parameters)
      path_params.each do |param_name|
        val = parameters[param_name.to_sym]
        raise "#{path} missing #{param_name}" unless val
        path = path.gsub(":"+param_name, val.to_s)
        parameters.delete(param_name.to_sym)
      end
      [path, parameters]
    end

    def initialize(config, context)
      @config = config
      @context = context
      @stack = []
    end

    def generate
      @stack = []
      visit @config.root
    end

    def visit(route)
      @stack.push route
      path = @config.base_url + current_path
      path_params = path.scan(/:(\w+)/).map { |arr| arr[0] }
      helper = Proc.new { |*args|
        formatted_path = path
        if (args.length)
          formatted_path, parameters = Generator.format_path(path, path_params, Generator.args_to_hash(*args))
        end
        if parameters.any?
          formatted_path += "?" + URI.encode_www_form(parameters)
        end
        formatted_path
      }
      _method = current_method
      define_helper = Proc.new {
        define_method _method, helper
      }
      @context.class_eval &define_helper
      route.children.each do |child|
        visit(child)
      end
      @stack.pop
    end

    def current_method
      if @stack.length > 1
        name = @stack[1..-1].map(&:name).join('_')
      else
        name = @stack.first.name
      end
      @config.prefix + name + "_path"
    end

    def current_path
      @stack.map(&:path).join('').gsub(/\/\//,'/')
    end

    def self.underscore(camel_cased_word)
      camel_cased_word.to_s
      .gsub(/^\//, '')
      .gsub(/\/$/, '')
      .gsub(/\//, '_')
      .gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
    end
  end
end
