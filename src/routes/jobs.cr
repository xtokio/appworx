get "/jobs" do |env|
  if Controller::Application.user_logged(env)
    jobs = Controller::Jobs.active()
    render "src/views/jobs/index.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end

get "/jobs/:id/tasks" do |env|
  if Controller::Application.user_logged(env)
    id = env.params.url["id"].to_i
    tasks = Controller::Tasks.get_by_job_id(id)

    render "src/views/tasks/index.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end

get "/jobs/new" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      render "src/views/jobs/new.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

post "/jobs/new" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Jobs.create(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end

get "/jobs/update/:id" do |env|
  if Controller::Application.user_logged(env)
      id = env.params.url["id"].to_i
      job = Controller::Jobs.get_by_id(id)
      render "src/views/jobs/update.ecr"
  else
      env.redirect "/login"
  end
end

post "/jobs/update" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Jobs.update(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end

get "/jobs/status" do |env|
  if Controller::Application.user_logged(env)
    job_status = Controller::JobStatus.all()
    render "src/views/job_status/index.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end

get "/jobs/status/:id" do |env|
  if Controller::Application.user_logged(env)
    job_status_id = env.params.url["id"].to_i
    job_status_tasks = Controller::TaskStatus.get_by_job_status_id(job_status_id)
    
    render "src/views/job_status/tasks.ecr"
  else
    error_code = "401"
    error_message = "Unauthorized access"
    render "src/views/error_page.ecr"
  end
end