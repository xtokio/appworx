class FileStorage
  extend BakedFileSystem

  bake_folder "../../public"

  def self.css
    files = [
      "/assets/css/base.css",
      "/assets/css/style.css"
    ]
    self.bake_files(files)
  end

  def self.js
    files = [
      "/assets/js/base.js",
      "/assets/js/app.js",
      "/assets/js/main.js"
    ]
    self.bake_files(files)
  end

  def self.login_css
    files = [
      "/assets/css/login.css"
    ]
    self.bake_files(files)
  end

  def self.login_js
    files = [
      "/assets/js/login.js"
    ]
    self.bake_files(files)
  end

  def self.image(image_path)
    Base64.encode(FileStorage.get(image_path).gets_to_end)
  end

  private def self.bake_files(files)
    output_string = ""
    files.each do |file|
      output_string = output_string + FileStorage.get(file).gets_to_end
    end
    output_string
  end

end