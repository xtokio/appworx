# TODO: Write documentation for `Appworx`
require "kemal"
require "kemal-session"
require "schedule"
require "sqlite3"
require "crecto"
require "baked_file_system"
require "./base/*"
require "./routes/*"
require "./models/*"
require "./controllers/*"

# public_folder ENV_HASH["PUBLIC_PATH"].to_s

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

  # Every second to validate it runs on the minute
  Schedule.every(1.second) do
    # Only search for active jobs if we are on the exact minute
    if Time.local.second == 0
      # Check if there are active Jobs
      jobs = Controller::Jobs.active()
      jobs.each do |job|
        current_date = Time.local
        schedule_time_hour = job.schedule_time||""
        schedule_time_hour = schedule_time_hour.split(":")[0]
        schedule_time_minute = job.schedule_time||""
        schedule_time_minute = schedule_time_minute.split(":")[1]

        # Run job only if Hour and Minute matches
        if current_date.hour == schedule_time_hour.to_i && current_date.minute == schedule_time_minute.to_i
          # Run job only if it's Daily of if it matches the day of the week
          if job.schedule == "Daily" || job.schedule == current_date.day_of_week.to_s
            spawn Controller::Jobs.run(job.id || 0)
          end
        end

      end

    end
  end

  get "/" do |env|
    puts "Rendering /"
    puts Controller::Application.user_logged(env)
    if env.session.int?("login")
      puts "Return true"
      puts env.session.int("login")
    end

    if Controller::Application.user_logged(env)
      puts "Rendering user logged!"
      jobs = Controller::Jobs.active()
      render "src/views/jobs/index.ecr", "src/layouts/base.ecr"
    else
      env.redirect "/login"
    end
  end

end
Kemal.config.env = "production"
Kemal.run(ENV_HASH["PORT"].to_i)