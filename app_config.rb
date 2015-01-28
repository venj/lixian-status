require "singleton"
require "yaml"

class AppConfig
  include Singleton

  def vars
    YAML.load(open(File.join(File.dirname(__FILE__), 'config.yml')).read)
  end
  
end