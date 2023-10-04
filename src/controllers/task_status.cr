module Controller
  module TaskStatus
    extend self

    Query = Crecto::Repo::Query

    def all()
      Model::ConnDB.all(Model::ViewTaskStatus)
    end

    def get_by_job_status_id(job_status_id : Int32)
      Model::ConnDB.all(Model::ViewTaskStatus, Query.where(job_status_id: job_status_id))
    end

    def create(job_status_id : Int32, job_id : Int32, task_id : (Int32 | Nil), status : String, response : String)
      
      table_record = Model::TaskStatus.new
      table_record.job_status_id   = job_status_id
      table_record.job_id   = job_id
      table_record.task_id  = task_id
      table_record.status   = status
      table_record.response = response
      changeset = Model::ConnDB.insert(table_record)

      changeset.instance.id || 0
    end

    def update(id : Int32, status : String, response : String)

      table_record = Model::ConnDB.get!(Model::TaskStatus, id)
      table_record.status   = status
      table_record.response = response
      changeset = Model::ConnDB.update(table_record)

      {status: "OK",id: id, message: "Task status : #{id} was updated."}.to_json
    end

  end
end