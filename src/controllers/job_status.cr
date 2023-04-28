module Controller
  module JobStatus
    extend self

    Query = Crecto::Repo::Query

    def all()
      Model::ConnDB.all(Model::ViewJobStatus, Query.order_by("id DESC"))
    end

    def get_by_id(id : Int32)
      Model::ConnDB.all(Model::ViewJobStatus, Query.where(id: id))
    end

    def get_by_job_id(job_id : Int32)
      Model::ConnDB.all(Model::ViewJobStatus, Query.where(job_id: job_id))
    end

    def create(job_id : Int32, status : String, response : String)
      
      table_record = Model::JobStatus.new
      table_record.job_id   = job_id
      table_record.status   = status
      table_record.response = response
      changeset = Model::ConnDB.insert(table_record)

      changeset.instance.id
    end

    def update(id : Int32, status : String, response : String)

      table_record = Model::ConnDB.get!(Model::JobStatus, id)
      table_record.status   = status
      table_record.response = response
      changeset = Model::ConnDB.update(table_record)
    end
  end
end