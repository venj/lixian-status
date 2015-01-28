require "sequel"
require File.join(File.dirname(__FILE__), 'history.rb')
require File.join(File.dirname(__FILE__), 'app_config.rb')

history = History.all
puts history.first[:task_uuid]