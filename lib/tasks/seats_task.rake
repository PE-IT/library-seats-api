desc 'Display the first room in database'
task :display_first_room => :environment do
  puts first_room.name
end

desc 'Display the user token'
task :display_token, [:username, :password] do |t, params|
  puts token(params.username, params.password)
end

desc 'Run all booking tasks'
task :run_all_tasks => :environment do
  page = Mechanize.new

  Task.find_each do |task|
    url = "http://seat.ujn.edu.cn/rest/v2/freeBook"
    data = {
      "token" => token(task.username, task.password),
      "startTime" => task.start,
      "endTime" => task.end,
      "seat" => task.seat.to_s,
      "date" => (Time.new + 86400).strftime("%Y-%m-%d")
    }

    page.post(url, data)
    pp page.page.body.force_encoding("utf-8")
  end
end


# --- Method ---

def first_room
  Room.first
end

def token user, pwd
  page = Mechanize.new
  page.get "http://seat.ujn.edu.cn/rest/auth?username=#{user}&password=#{pwd}"
  JSON.parse(page.page.body)['data']['token']
end
