require 'ember_routes/config'
require 'ember_routes/generator'
require 'ember_routes/path_helpers'
require 'ember_routes/route'

module EmberRoutes
  def self.configure
    c = Config.new
    yield c
    gen = Generator.new(c, PathHelpers)
    gen.generate
    c
  end
end
