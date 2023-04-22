get "/dashboard" do |env|
  if Controller::Application.user_logged(env)
    render "src/views/dashboard/index.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end