# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

class Slowdown
  def initialize(app)
    @app = app
  end

  def call(env)
    sleep(rand(10))
    @app.call(env)
  end
end

use Slowdown
run Stresster::Application
