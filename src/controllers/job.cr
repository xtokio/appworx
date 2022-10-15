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

    def run(job_id : Int32)
      # Search for job tasks
      tasks = Controller::Tasks.get_by_job_id(job_id)
      tasks.each do |task|
        command = task.code||""
        puts "Executing Task : #{task.description}"
        # Execute task
        status, output = execute_task(command)

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