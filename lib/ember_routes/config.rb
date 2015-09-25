module EmberRoutes
  class Config

    attr_accessor :base_url, :prefix
    attr_reader :root

    def initialize
      @root = Route.new('root', :path => '/')
      @base_url = ''
      @prefix = ''
    end

    def config(&block)
      generate_methods
    end

    def routes(&block)
      @root.instance_eval &block
    end

  end
end
