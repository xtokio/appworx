module Controller
    module Tasks
      extend self

      Query = Crecto::Repo::Query

      def all()
        Model::ConnDB.all(Model::ViewTask)
      end

      def active()
        Model::ConnDB.all(Model::ViewTask, Query.where(active: 1))
      end

      def get_by_id(id : Int32)
        Model::ConnDB.all(Model::ViewTask, Query.where(id: id))
      end

      def get_by_job_id(job_id : Int32)
        Model::ConnDB.all(Model::ViewTask, Query.where(active: 1).where(job_id: job_id))
      end

      def create(env)
        job_id      = env.params.json["job_id"].as(Int64)
        task        = env.params.json["task"].as(String)
        description = env.params.json["description"].as(String)
        language    = env.params.json["language"].as(String)
        command     = env.params.json["command"].as(String)
        active      = env.params.json["active"].as(String)
        
        table_record = Model::Task.new
        table_record.job_id      = job_id.to_i
        table_record.task        = task
        table_record.description = description
        table_record.language    = language
        table_record.command     = command
        table_record.active      = active.to_i
        changeset = Model::ConnDB.insert(table_record)
  
        task_id = changeset.instance.id
  
        {status: "OK",id: task_id, message: "Task : #{task_id} was created."}.to_json
      end
  
      def update(env)
        id          = env.params.json["id"].as(String)
        job_id      = env.params.json["job_id"].as(Int64)
        task        = env.params.json["task"].as(String)
        description = env.params.json["description"].as(String)
        language    = env.params.json["language"].as(String)
        command     = env.params.json["command"].as(String)
        active      = env.params.json["active"].as(String)
  
        table_record = Model::ConnDB.get!(Model::Task, id)
        table_record.job_id      = job_id.to_i
        table_record.task        = task
        table_record.description = description
        table_record.language    = language
        table_record.command     = command
        table_record.active      = active.to_i
        changeset = Model::ConnDB.update(table_record)
  
        {status: "OK",id: id, message: "Task : #{id} was updated."}.to_json
      end

    end
end