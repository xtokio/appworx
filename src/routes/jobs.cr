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

get "/jobs/:id/tasks" do |env|
  if Controller::Application.user_logged(env)
    id = env.params.url["id"].to_i
    jobs  = Controller::Jobs.active()
    tasks = Controller::Tasks.get_by_job_id(id)

    render "src/views/dashboard/tasks.ecr", "src/layouts/base.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end