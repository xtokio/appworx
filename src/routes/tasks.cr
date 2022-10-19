get "/tasks/new/:id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      job_id = env.params.url["id"].to_i
      render "src/views/tasks/new.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

post "/tasks/new" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Tasks.create(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end

get "/tasks/update/:id" do |env|
  if Controller::Application.user_logged(env)
      id = env.params.url["id"].to_i
      task = Controller::Tasks.get_by_id(id)
      render "src/views/tasks/update.ecr"
  else
      env.redirect "/login"
  end
end

post "/tasks/update" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Tasks.update(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end