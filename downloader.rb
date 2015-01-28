require File.join(File.dirname(__FILE__), 'common.rb')
require "fileutils"
include FileUtils

def download_data(history)
  puts "Start to download #{history[:file_name]}"
  download(history[:task_uuid])
end

def download(uuid)
  history = History.find(task_uuid: uuid)

  config = AppConfig.instance
  lx = config.vars["lx_command"]
  history[:fetch_status] = "downloading"
  history.save
  cd download_dir do
    result = system "#{lx} download #{uuid} --continue > /dev/null 2>&1"
    if !result
      puts "Failed to download #{history[:file_name]}"
      history[:fetch_status] = "failed"
      history.save
    else
      history[:fetch_status] = "finished"
      history.save
      puts "Finished downloading #{history[:file_name]}"
    end
  end
end

def download_dir
  config = AppConfig.instance
  dir = config.vars["download_dir"]
  mkdir_p dir unless File.directory? dir
  dir
end

def down_them_all
  histories = History.all
  histories.each do |history|
    fetch_status = history[:fetch_status]
    if fetch_status == "waiting" || fetch_status == "failed"  || fetch_status == "downloading"
      download_data history
    end
  end
end

def main
  if File.open("/tmp/#{File.basename $0}.lock", File::RDWR|File::CREAT, 0644).flock(File::LOCK_EX)
    down_them_all
  end
end

main
