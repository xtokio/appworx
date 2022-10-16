get "/jobs" do |env|
  if Controller::Application.user_logged(env)
    jobs = Controller::Jobs.active()
    render "src/views/dashboard/index.ecr", "src/layouts/base.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end