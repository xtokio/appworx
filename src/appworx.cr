# TODO: Write documentation for `Appworx`
require "kemal"
require "kemal-session"
require "schedule"
require "sqlite3"
require "crecto"
require "./routes/*"
require "./models/*"
require "./controllers/*"

# Default values
ENV_HASH = {"PUBLIC_PATH"=>Dir.current + "/public","PORT"=>3000,"DATABASE_PATH"=>Dir.current + "/db/appworx.db"}

# Check .env
File.each_line(".env") do |line|
    key = line.split("=")[0]
    val = line.split("=")[1]
    if key == "PUBLIC_PATH"
      ENV_HASH["PUBLIC_PATH"] = val
    end
    if key == "PORT"
      ENV_HASH["PORT"] = val
    end
    if key == "DATABASE_PATH"
      ENV_HASH["DATABASE_PATH"] = val
    end
end if File.file?(".env")

public_folder ENV_HASH["PUBLIC_PATH"].to_s

module Appworx
  VERSION = "0.1.0"

  # TODO: Put your code here
  Kemal::Session.config.secret = "9e7abe8ae041296820a0b69ef0e4a397c87f5866f454d35d432840bc98cfd789439addc260bb6f9a058e88faa7e4a4e416e39d05273f459dd3373dc6387cf69c"
    
  static_headers do |response, filepath, filestat|
    response.headers.add("Cache-control", "public")
    response.headers.add("Cache-control", "max-age=31557600")
    response.headers.add("Cache-control", "s-max-age=31557600")
    response.headers.add("Content-Size", filestat.size.to_s)
  end

  error 404 do
    error_code = "404"
    error_message = "Page / Resource not found"
    render "src/views/error_page.ecr"
  end

  error 500 do
    error_code = "500"
    error_message = "Server error"
    render "src/views/error_page.ecr"
  end

  # Every 35 seconds to ensure only runs once within the minute
  Schedule.every(35.seconds) do
    jobs = Controller::Jobs.active()
    jobs.each do |job|
      current_date = Time.local

      schedule_time_hour = job.schedule_time||""
      schedule_time_hour = schedule_time_hour.split(":")[0]

      schedule_time_minute = job.schedule_time||""
      schedule_time_minute = schedule_time_minute.split(":")[1]

      # Run job only if Hour and Minute matches
      if current_date.hour == schedule_time_hour.to_i && current_date.minute == schedule_time_minute.to_i
        spawn Controller::Jobs.run(job.id || 0)
      end

    end
  end

  get "/" do |env|
    if Controller::Application.user_logged(env)
      jobs = Controller::Jobs.active()
      render "src/views/jobs/index.ecr", "src/layouts/base.ecr"
    else
      env.redirect "/login"
    end
  end

end
Kemal.run(ENV_HASH["PORT"].to_i)