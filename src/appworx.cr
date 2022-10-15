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
  Schedule.every(10.seconds) do
    Controller::Jobs.run(1)
    # puts "Hello! - #{Time.local}"
  end

end
Kemal.run(ENV_HASH["PORT"].to_i)