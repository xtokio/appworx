module Controller
  module Jobs
    extend self

    Query = Crecto::Repo::Query

    def all()
      Model::ConnDB.all(Model::Job)
    end

    def active()
      Model::ConnDB.all(Model::Job, Query.where(active: 1))
    end

    def get_by_id(id : Int32)
      Model::ConnDB.all(Model::Job, Query.where(id: id))
    end

    def create(env)
      job           = env.params.json["job"].as(String)
      description   = env.params.json["description"].as(String)
      schedule      = env.params.json["schedule"].as(String)
      schedule_time = env.params.json["schedule_time"].as(String)
      active        = env.params.json["active"].as(String)
      
      table_record = Model::Job.new
      table_record.job           = job
      table_record.description   = description
      table_record.schedule      = schedule
      table_record.schedule_time = schedule_time
      table_record.active        = active.to_i
      table_record.user_id       = env.session.string("user_id").to_i
      changeset = Model::ConnDB.insert(table_record)

      job_id = changeset.instance.id

      {status: "OK",id: job_id, message: "Job : #{job_id} was created."}.to_json
    end

    def update(env)
      id            = env.params.json["id"].as(String)
      job   = env.params.json["job"].as(String)
      description   = env.params.json["description"].as(String)
      schedule      = env.params.json["schedule"].as(String)
      schedule_time = env.params.json["schedule_time"].as(String)
      active        = env.params.json["active"].as(String)

      table_record = Model::ConnDB.get!(Model::Job, id)
      table_record.job           = job
      table_record.description   = description
      table_record.schedule      = schedule
      table_record.schedule_time = schedule_time
      table_record.active        = active.to_i
      table_record.user_id       = env.session.string("user_id").to_i
      changeset = Model::ConnDB.update(table_record)

      {status: "OK",id: id, message: "Job : #{id} was updated."}.to_json
    end

    def run(job_id : Int32)
      puts "Executing Job ID #{job_id}"
      # Search for job tasks
      tasks = Controller::Tasks.get_by_job_id(job_id)
      tasks.each do |task|
        command = task.command||""
        puts "Executing Task : #{task.task_description}"

        task_status_id = Controller::TaskStatus.create(job_id,task.id || 0,"Queue","")
        
        # Execute task
        status, output = execute_task(command)

        response_status = status == 0 ? "Done" : "Failed"
        Controller::TaskStatus.update(task_status_id || 0,response_status,output)

        puts "Status: #{status}"
        puts "Response: #{output}"
        break unless status == 0
      end
    end

    def execute_task(command)
      stdout = IO::Memory.new
      stderr = IO::Memory.new
      status = Process.run(command, shell: true, output: stdout, error: stderr)
      if status.success?
        {status.exit_code, stdout.to_s}
      else
        {status.exit_code, stderr.to_s}
      end
    end

  end
end