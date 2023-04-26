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