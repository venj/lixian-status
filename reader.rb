require File.join(File.dirname(__FILE__), 'common.rb')

def main
  config = AppConfig.instance
  lx = config.vars["lx_command"]

  begin
    result = `#{lx} list --size`  
  rescue StandardError => e
    puts "Error fetching data from Xunlei"
    exit 1
  end

  result.each_line do |line|
    parts = line.split(/\s+/)
    next if parts[parts.size - 2] != "completed" # skip not completed tasks
    data = History.find(task_uuid: parts[0])
    if data.nil?
      history = History.new(task_uuid: parts[0], lixian_status: parts[parts.size - 2], fetch_status: "waiting", 
        file_size: parts.last, file_name: parts[1...(parts.size - 2)].join(" "))
      history.save
    end
  end
end

main
