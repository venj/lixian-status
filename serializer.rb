require "sequel"
require File.join(File.dirname(__FILE__), 'app_config.rb')
require "fileutils"

class Serializer
  attr_reader :db
  def initialize(args=[])
    config = AppConfig.instance
    db_path = File.join(File.dirname(__FILE__), config.vars["sqlite_path"])
    
    unless File.exists? db_path
      Sequel.sqlite(db_path)
    end
    @db = Sequel.connect("sqlite://#{db_path}")
  end
  
  def db_init
    @db.create_table :histories do
      String :task_uuid
      String :file_name
      String :lixian_status
      String :fetch_status
      String :file_size
    end

    histories = @db[:histories]
  end

  def db_destroy
    config = AppConfig.instance
    db_path = File.join(File.dirname(__FILE__), config.vars["sqlite_path"])
    FileUtils.rm db_path
  end
  
end