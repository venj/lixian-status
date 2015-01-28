require File.join(File.dirname(__FILE__), 'app_config.rb')

config = AppConfig.instance
db_path = File.join(File.dirname(__FILE__), config.vars["sqlite_path"])

unless File.exists? db_path
  Sequel.sqlite(db_path)
end
DB = Sequel.connect("sqlite://#{db_path}")

class History < Sequel::Model
  set_primary_key [:task_uuid]
end
